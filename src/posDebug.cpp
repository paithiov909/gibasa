#define R_NO_REMAP

#include <Rcpp.h>

#include "mecab.h"

using namespace Rcpp;

//' Get dictionary information
//'
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @returns data.frame.
//'
//' @name dictionary_info
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::DataFrame dictionary_info(const std::string& sys_dic = "",
                                const std::string& user_dic = "") {
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
    Rcpp::warning(
        "Failed to create MeCab::Model: maybe provided an invalid dictionary?");
    return R_NilValue;
  }

  std::vector<std::string> filenames;
  std::vector<std::string> charsets;
  std::vector<unsigned int> lsize;
  std::vector<unsigned int> rsize;
  std::vector<unsigned int> size;
  std::vector<int> type;
  std::vector<unsigned short> version;

  std::string charset;
  std::string filename;

  const MeCab::DictionaryInfo* d = model->dictionary_info();
  for (; d; d = d->next) {
    charset = std::string(d->charset);
    filename = std::string(d->filename);

    filenames.push_back(filename);
    charsets.push_back(charset);
    lsize.push_back(d->lsize);
    rsize.push_back(d->rsize);
    size.push_back(d->size);
    type.push_back(d->type);
    version.push_back(d->version);
  }

  MeCab::deleteModel(model);

  return Rcpp::DataFrame::create(_["file_path"] = filenames,
                                 _["charset"] = charsets, _["lsize"] = lsize,
                                 _["rsize"] = rsize, _["size"] = size,
                                 _["type"] = type, _["version"] = version);
}

//' Get transition cost between pos attributes
//'
//' @param rcAttr Integer.
//' @param lcAttr Integer.
//' @param sys_dic String.
//' @param user_dic String.
//' @returns Numeric.
//'
//' @name transition_cost
//' @keywords internal
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
int transition_cost(unsigned short rcAttr, unsigned short lcAttr,
                    const std::string& sys_dic = "", const std::string& user_dic = "") {
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

  const int t_cost = model->transition_cost(rcAttr, lcAttr);

  MeCab::deleteModel(model);
  return t_cost;
}

//' Tokenizer for debug use
//'
//' Tokenizes a character vector
//' and returns all possible results out of the tokenization process.
//' The returned data.frame contains additional attributes for debug usage.
//'
//' @param text String.
//' @param sys_dic String.
//' @param user_dic String.
//' @param partial Logical.
//' @returns data.frame.
//'
//' @name posDebugRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::DataFrame posDebugRcpp(const std::vector<std::string>& text,
                             const std::string& sys_dic = "",
                             const std::string& user_dic = "",
                             Rcpp::LogicalVector partial = 0) {
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

  std::vector<int> docids;
  std::vector<unsigned short> posids;
  std::vector<std::string> surfaces;
  std::vector<std::string> features;
  std::vector<unsigned char> stats;
  std::vector<unsigned short> lcAttr;
  std::vector<unsigned short> rcAttr;
  std::vector<float> alpha;
  std::vector<float> beta;
  std::vector<unsigned char> isbest;
  std::vector<float> prob;
  std::vector<short> wcost;
  std::vector<long> cost;

  MeCab::Tagger* tagger = model->createTagger();
  MeCab::Lattice* lattice = model->createLattice();
  const MeCab::Node* node;

  if (is_true(all(partial))) {
    lattice->add_request_type(MECAB_PARTIAL);
  } else {
    lattice->add_request_type(MECAB_ALL_MORPHS);
  }
  lattice->add_request_type(MECAB_MARGINAL_PROB);

  for (std::size_t i = 0; i < text.size(); ++i) {
    if (i % 100 == 0) checkUserInterrupt();

    std::string input = text[i];
    if (is_true(all(partial))) input += "\nEOS";

    lattice->set_sentence(input.c_str());
    if (!tagger->parse(lattice)) {
      std::string err = MeCab::getLastError();
      Rcpp::stop(err);
    }
    node = lattice->bos_node();

    std::string surface;
    std::string feature;

    for (; node; node = node->next) {
      surface = std::string(node->surface).substr(0, node->length);
      feature = std::string(node->feature);

      docids.push_back(i + 1);
      posids.push_back(node->posid);
      surfaces.push_back(surface);
      features.push_back(feature);
      stats.push_back(node->stat);
      lcAttr.push_back(node->lcAttr);
      rcAttr.push_back(node->rcAttr);
      alpha.push_back(node->alpha);
      beta.push_back(node->beta);
      isbest.push_back(node->isbest);
      prob.push_back(node->prob);
      wcost.push_back(node->wcost);
      cost.push_back(node->cost);
    }
  }

  MeCab::deleteLattice(lattice);
  MeCab::deleteTagger(tagger);
  MeCab::deleteModel(model);

  return Rcpp::DataFrame::create(
      _["doc_id"] = docids, _["pos_id"] = posids, _["surface"] = surfaces,
      _["feature"] = features, _["stat"] = stats, _["lcAttr"] = lcAttr,
      _["rcAttr"] = rcAttr, _["alpha"] = alpha, _["beta"] = beta,
      _["is_best"] = isbest, _["prob"] = prob, _["wcost"] = wcost,
      _["cost"] = cost);
}
