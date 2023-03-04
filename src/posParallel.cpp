// [[Rcpp::depends(RcppParallel)]]
#define R_NO_REMAP

#include <iostream>
#include <sstream>
#include <Rcpp.h>
#include <RcppParallel.h>
#include "mecab.h"

using namespace Rcpp;

struct TextParse : public RcppParallel::Worker
{
  const std::vector<std::string>* sentences_;
  std::vector<std::vector<std::tuple<std::string, std::string>>>& results_;
  mecab_model_t* model_;
  const bool* partial_;

  TextParse(const std::vector<std::string>* sentences, std::vector<std::vector<std::tuple<std::string, std::string>>>& results, mecab_model_t* model, const bool* is_partial_mode)
    : sentences_(sentences), results_(results), model_(model), partial_(is_partial_mode) {}

  void operator()(std::size_t begin, std::size_t end)
  {
    mecab_t* tagger = mecab_model_new_tagger(model_);
    mecab_lattice_t* lattice = mecab_model_new_lattice(model_);
    const mecab_node_t* node;

    if (*partial_) {
      mecab_lattice_add_request_type(lattice, MECAB_PARTIAL);
    }

    for (size_t i = begin; i < end; ++i) {
      if (*partial_) {
        mecab_lattice_set_sentence(lattice, ((*sentences_)[i] + "\nEOS").c_str());
      } else {
        mecab_lattice_set_sentence(lattice, (*sentences_)[i].c_str());
      }
      mecab_parse_lattice(tagger, lattice);

      const size_t len = mecab_lattice_get_size(lattice);

      std::vector<std::tuple<std::string, std::string>> parsed;
      parsed.reserve(len);

      node = mecab_lattice_get_bos_node(lattice);

      for (; node; node = node->next) {
        if (node->stat == MECAB_BOS_NODE)
          ;
        else if (node->stat == MECAB_EOS_NODE)
          ;
        else {
          std::string morph = std::string(node->surface).substr(0, node->length);
          std::string features = std::string(node->feature);
          parsed.push_back(std::make_tuple(morph, features));
        }
      }
      results_[i] = parsed;
    }

    mecab_lattice_destroy(lattice);
    mecab_destroy(tagger);
  }

};

//' Call tagger inside 'RcppParallel::parallelFor' and return a data.frame.
//'
//' @param text Character vector.
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @param partial Logical.
//' @param grain_size Integer (larger than 1).
//' @return data.frame.
//'
//' @name posParallelRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::DataFrame posParallelRcpp(std::vector<std::string> text,
                                std::string sys_dic = "",
                                std::string user_dic = "",
                                Rcpp::LogicalVector partial = 0,
                                std::size_t grain_size = 1) {
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
  std::copy(args.begin(), args.end(), std::ostream_iterator<std::string>(os, delim));
  std::string argv = os.str();

  // lattice model
  mecab_model_t* model;

  // create model
  model = mecab_model_new2(argv.c_str());
  if (!model) {
    Rcerr << "failed to create mecab_model_t: maybe provided an invalid dictionary?" << std::endl;
    mecab_model_destroy(model);
    return R_NilValue;
  }

  std::vector<std::vector<std::tuple<std::string, std::string>>> results(text.size());
  std::vector<int> sentence_id;
  std::vector<int> token_id;
  std::vector<std::string> token;
  std::vector<std::string> pos;

  int sentence_number = 0;
  int token_number = 1;

  bool is_partial_mode = false;
  if (is_true(all(partial))) { is_partial_mode = true; }

  TextParse text_parse(&text, results, model, &is_partial_mode);
  RcppParallel::parallelFor(0, text.size(), text_parse, grain_size);

  // clean
  mecab_model_destroy(model);

  // make columns for result data.frame.
  for (size_t k = 0; k < results.size(); ++k) {
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

  return DataFrame::create(
    _["sentence_id"] = sentence_id,
    _["token_id"] = token_id,
    _["token"] = token,
    _["feature"] = pos,
    _["stringsAsFactors"] = false
  );
}
