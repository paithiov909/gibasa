// [[Rcpp::depends(RcppParallel)]]
#ifndef R_NO_REMAP
#define R_NO_REMAP
#endif

#include <Rcpp.h>
#include <RcppParallel.h>

#include <iostream>
#include <sstream>

#include "mecab.h"

using namespace Rcpp;

struct TextParser : public RcppParallel::Worker {
  const std::vector<std::string>* sentences_;
  std::vector<std::vector<std::tuple<std::string, std::string>>>& results_;
  MeCab::Model* model_;
  const bool* partial_;

  TextParser(
      const std::vector<std::string>* sentences,
      std::vector<std::vector<std::tuple<std::string, std::string>>>& results,
      MeCab::Model* model, const bool* is_partial_mode)
      : sentences_(sentences),
        results_(results),
        model_(model),
        partial_(is_partial_mode) {}

  void operator()(std::size_t begin, std::size_t end) {
    MeCab::Tagger* tagger = model_->createTagger();
    MeCab::Lattice* lattice = model_->createLattice();
    const MeCab::Node* node;

    if (*partial_) {
      lattice->add_request_type(MECAB_PARTIAL);
    }
    for (std::size_t i = begin; i < end; ++i) {
      if (*partial_) {
        lattice->set_sentence(((*sentences_)[i] + "\nEOS").c_str());
      } else {
        lattice->set_sentence((*sentences_)[i].c_str());
      }
      try {
        if (tagger->parse(lattice)) {
          const std::size_t len = lattice->size();
          std::vector<std::tuple<std::string, std::string>> parsed;
          parsed.reserve(len);

          node = lattice->bos_node();

          std::string morph;
          std::string features;

          for (; node; node = node->next) {
            if (node->stat == MECAB_BOS_NODE)
              ;
            else if (node->stat == MECAB_EOS_NODE)
              ;
            else {
              morph = std::string(node->surface).substr(0, node->length);
              features = std::string(node->feature);
              parsed.push_back(std::make_tuple(morph, features));
            }
          }
          results_[i] = parsed;
        }
      } catch (const std::exception& e) {
        std::string err = e.what();
        err += " Parsing failed at sentence: %s";
        Rcpp::warning(err.c_str(), i + 1);
        continue;
      }
    }
    MeCab::deleteLattice(lattice);
    MeCab::deleteTagger(tagger);
  }
};

//' Call tagger inside 'RcppParallel::parallelFor' and return a data.frame.
//'
//' This function is an internal function called by `tokenize()`.
//' For common usage, use `tokenize()` instead.
//'
//' @param text A character vector to be tokenized.
//' @param sys_dic Character scalar; path to the system dictionary for 'MeCab'.
//' @param user_dic Character scalar; path to the user dictionary for 'MeCab'.
//' @param partial Logical; If `TRUE`, activates partial parsing mode.
//' @param grain_size Integer value larger than 1.
//' @returns A data.frame.
//'
//' @name posParallelRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::DataFrame posParallelRcpp(const std::vector<std::string>& text,
                                const std::string& sys_dic = "",
                                const std::string& user_dic = "",
                                Rcpp::LogicalVector partial = 0,
                                const std::size_t& grain_size = 1) {
  std::vector<std::string> args;
  args.push_back("mecab");
  if (sys_dic != "") {
    args.push_back("-d");
    args.push_back(sys_dic);
  }
  if (user_dic != "") {
    args.push_back("-u");
    args.push_back(user_dic);
  }
  const char* delim = " ";
  std::ostringstream os;
  std::copy(args.begin(), args.end(),
            std::ostream_iterator<std::string>(os, delim));
  std::string argv = os.str();

  MeCab::Model* model = MeCab::createModel(argv.c_str());
  if (!model) {
    Rcpp::stop(
        "Failed to create MeCab::Model: maybe provided an invalid dictionary?");
  }

  std::vector<std::vector<std::tuple<std::string, std::string>>> results(
      text.size());
  std::vector<int> sentence_id;
  std::vector<int> token_id;
  std::vector<std::string> token;
  std::vector<std::string> pos;

  int sentence_number = 0;
  int token_number = 1;

  bool is_partial_mode = is_true(all(partial)) ? true : false;

  TextParser text_parse(&text, results, model, &is_partial_mode);
  RcppParallel::parallelFor(0, text.size(), text_parse, grain_size);

  // clean
  MeCab::deleteModel(model);

  // make columns for result data.frame.
  for (std::size_t k = 0; k < results.size(); ++k) {
    // check user interrupt (Ctrl+C).
    if (k % 1000 == 0) checkUserInterrupt();

    std::vector<std::tuple<std::string, std::string>>::const_iterator l;
    for (l = results[k].begin(); l != results[k].end(); ++l) {
      token.push_back(std::get<0>(*l));
      pos.push_back(std::get<1>(*l));

      token_id.push_back(token_number);
      token_number++;

      sentence_id.push_back(sentence_number + 1);
    }
    token_number = 1;
    sentence_number++;
  }

  return Rcpp::DataFrame::create(
      _["sentence_id"] = sentence_id, _["token_id"] = token_id,
      _["token"] = token, _["feature"] = pos, _["stringsAsFactors"] = false);
}
