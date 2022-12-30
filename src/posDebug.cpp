#define R_NO_REMAP

#include <Rcpp.h>
#include "mecab.h"

using namespace Rcpp;

//' Get dictionary information
//'
//' @param sys_dic String scalar.
//' @param user_dic String scalar.
//' @return data.frame.
//'
//' @name dictionary_info
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::DataFrame dictionary_info(std::string sys_dic = "",
                                std::string user_dic = "") {
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

  mecab_model_t* model = mecab_model_new2(argv.c_str());
  if (!model) {
    Rcerr << "failed to create mecab_model_t: maybe provided an invalid dictionary?" << std::endl;
    mecab_model_destroy(model);
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

  const mecab_dictionary_info_t* d = mecab_model_dictionary_info(model);
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

  mecab_model_destroy(model);

  return DataFrame::create(
    _["file_path"] = filenames,
    _["charset"] = charsets,
    _["lsize"] = lsize,
    _["rsize"] = rsize,
    _["size"] = size,
    _["type"] = type,
    _["version"] = version
  );
}

//' Get transition cost between pos attributes
//'
//' @param rcAttr Integer.
//' @param lcAttr Integer.
//' @param sys_dic String.
//' @param user_dic String.
//' @return Numeric.
//'
//' @name transition_cost
//' @keywords internal
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
int transition_cost(unsigned short rcAttr,
                    unsigned short lcAttr,
                    std::string sys_dic = "",
                    std::string user_dic = "") {
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

  mecab_model_t* model = mecab_model_new2(argv.c_str());
  if (!model) {
    Rcerr << "failed to create mecab_model_t: maybe provided an invalid dictionary?" << std::endl;
    mecab_model_destroy(model);
    return 0;
  }

  const int t_cost = mecab_model_transition_cost(model, rcAttr, lcAttr);

  mecab_model_destroy(model);
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
//' @return data.frame.
//'
//' @name posDebugRcpp
//' @keywords internal
//' @export
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
Rcpp::DataFrame posDebugRcpp(std::vector<std::string> text,
                             std::string sys_dic = "",
                             std::string user_dic = "",
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
  std::copy(args.begin(), args.end(), std::ostream_iterator<std::string>(os, delim));
  std::string argv = os.str();

  mecab_model_t* model = mecab_model_new2(argv.c_str());
  if (!model) {
    Rcerr << "failed to create mecab_model_t: maybe provided an invalid dictionary?" << std::endl;
    mecab_model_destroy(model);
    return R_NilValue;
  }

  std::vector<int> docids;
  std::vector<unsigned short> posids;
  std::vector<std::string> surfaces;
  std::vector<std::string> features;
  std::vector<unsigned char> stats;
  std::vector<unsigned short> rcAttr;
  std::vector<unsigned short> lcAttr;
  std::vector<float> alpha;
  std::vector<float> beta;
  std::vector<unsigned char> isbest;
  std::vector<float> prob;
  std::vector<short> wcost;
  std::vector<long> cost;

  mecab_t* tagger = mecab_model_new_tagger(model);
  mecab_lattice_t* lattice = mecab_model_new_lattice(model);
  const mecab_node_t* node;

  if (is_true(all(partial))) {
    mecab_lattice_add_request_type(lattice, MECAB_PARTIAL);
  } else {
    mecab_lattice_add_request_type(lattice, MECAB_ALL_MORPHS);
  }
  mecab_lattice_add_request_type(lattice, MECAB_MARGINAL_PROB);

  for (size_t i = 0; i < text.size(); ++i) {
    if (i % 100 == 0) checkUserInterrupt();

    std::string input = text[i];
    if (is_true(all(partial))) input += "\nEOS";

    mecab_lattice_set_sentence(lattice, input.c_str());
    mecab_parse_lattice(tagger, lattice);
    node = mecab_lattice_get_bos_node(lattice);

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
      rcAttr.push_back(node->rcAttr);
      lcAttr.push_back(node->lcAttr);
      alpha.push_back(node->alpha);
      beta.push_back(node->beta);
      isbest.push_back(node->isbest);
      prob.push_back(node->prob);
      wcost.push_back(node->wcost);
      cost.push_back(node->cost);
    }
  }

  mecab_model_destroy(model);

  return DataFrame::create(
    _["doc_id"] = docids,
    _["pos_id"] = posids,
    _["surface"] = surfaces,
    _["feature"] = features,
    _["stat"] = stats,
    _["rcAttr"] = rcAttr,
    _["lcAttr"] = lcAttr,
    _["alpha"] = alpha,
    _["beta"] = beta,
    _["is_best"] = isbest,
    _["prob"] = prob,
    _["wcost"] = wcost,
    _["cost"] = cost
  );
}

