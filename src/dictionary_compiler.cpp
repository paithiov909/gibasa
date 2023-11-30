//  MeCab -- Yet Another Part-of-Speech and Morphological Analyzer
//
//  Copyright(C) 2001-2006 Taku Kudo <taku@chasen.org>
//  Copyright(C) 2004-2006 Nippon Telegraph and Telephone Corporation
#include <iostream>
#include <map>
#include <string>
#include <vector>

#include "char_property.h"
#include "connector.h"
#include "dictionary.h"
#include "dictionary_rewriter.h"
#include "feature_index.h"
#include "mecab.h"
#include "param.h"

namespace MeCab {

class DictionaryComplier {
 public:
  static int run(int argc, char** argv) {
    static const MeCab::Option long_options[] = {
        {"dicdir", 'd', ".", "DIR", "set DIR as dic dir (default \".\")"},
        {"outdir", 'o', ".", "DIR", "set DIR as output dir (default \".\")"},
        {"model", 'm', 0, "FILE", "use FILE as model file"},
        {"userdic", 'u', 0, "FILE", "build user dictionary"},
        {"assign-user-dictionary-costs", 'a', 0, 0,
         "only assign costs/ids to user dictionary"},
        {"build-unknown", 'U', 0, 0, "build parameters for unknown words"},
        {"build-model", 'M', 0, 0, "build model file"},
        {"build-charcategory", 'C', 0, 0, "build character category maps"},
        {"build-sysdic", 's', 0, 0, "build system dictionary"},
        {"build-matrix", 'm', 0, 0, "build connection matrix"},
        {"charset", 'c', MECAB_DEFAULT_CHARSET, "ENC",
         "make charset of binary dictionary ENC (default " MECAB_DEFAULT_CHARSET
         ")"},
        {"charset", 't', MECAB_DEFAULT_CHARSET, "ENC", "alias of -c"},
        {"dictionary-charset", 'f', MECAB_DEFAULT_CHARSET, "ENC",
         "assume charset of input CSVs as ENC (default " MECAB_DEFAULT_CHARSET
         ")"},
        {
            "wakati",
            'w',
            0,
            0,
            "build wakati-gaki only dictionary",
        },
        {"posid", 'p', 0, 0, "assign Part-of-speech id"},
        {"node-format", 'F', 0, "STR",
         "use STR as the user defined node format"},
        {"version", 'v', 0, 0, "show the version and exit."},
        {"help", 'h', 0, 0, "show this help and exit."},
        {NULL, '\0', 0, 0, NULL}};

    Param param;

    if (!param.open(argc, argv, long_options)) {
      Rcpp::Rcout << param.what() << "\n\n"
                  << COPYRIGHT << "\ntry '--help' for more information."
                  << std::endl;
      return -1;
    }

    if (!param.help_version()) {
      return 0;
    }

    const std::string dicdir = param.get<std::string>("dicdir");
    const std::string outdir = param.get<std::string>("outdir");
    bool opt_unknown = param.get<bool>("build-unknown");
    bool opt_matrix = param.get<bool>("build-matrix");
    bool opt_charcategory = param.get<bool>("build-charcategory");
    bool opt_sysdic = param.get<bool>("build-sysdic");
    bool opt_model = param.get<bool>("build-model");
    bool opt_assign_user_dictionary_costs =
        param.get<bool>("assign-user-dictionary-costs");
    const std::string userdic = param.get<std::string>("userdic");

    // #define DCONF(file) create_filename(dicdir, std::string(file)).c_str()
    // #define OCONF(file) create_filename(outdir, std::string(file)).c_str()

    CHECK_DIE(param.load(create_filename(dicdir, "dicrc").c_str()))
        << "no such file or directory: " << create_filename(dicdir, DICRC);

    std::vector<std::string> dic;
    if (userdic.empty()) {
      enum_csv_dictionaries(dicdir.c_str(), &dic);
    } else {
      dic = param.rest_args();
    }

    if (!userdic.empty()) {
      CHECK_DIE(dic.size()) << "no dictionaries are specified";
      param.set("type", static_cast<int>(MECAB_USR_DIC));
      if (opt_assign_user_dictionary_costs) {
        Dictionary::assignUserDictionaryCosts(param, dic, userdic.c_str());
      } else {
        Dictionary::compile(param, dic, userdic.c_str());
      }
    } else {
      if (!opt_unknown && !opt_matrix && !opt_charcategory && !opt_sysdic &&
          !opt_model) {
        opt_unknown = opt_matrix = opt_charcategory = opt_sysdic = opt_model =
            true;
      }

      if (opt_charcategory || opt_unknown) {
        CharProperty::compile(
            create_filename(dicdir, CHAR_PROPERTY_DEF_FILE).c_str(),
            create_filename(dicdir, UNK_DEF_FILE).c_str(),
            create_filename(outdir, CHAR_PROPERTY_FILE).c_str());
      }

      if (opt_unknown) {
        std::vector<std::string> tmp;
        tmp.push_back(create_filename(dicdir, UNK_DEF_FILE));
        param.set("type", static_cast<int>(MECAB_UNK_DIC));
        Dictionary::compile(param, tmp,
                            create_filename(outdir, UNK_DIC_FILE).c_str());
      }

      if (opt_model) {
        if (file_exists(create_filename(dicdir, MODEL_DEF_FILE).c_str())) {
          FeatureIndex::compile(param,
                                create_filename(dicdir, MODEL_DEF_FILE).c_str(),
                                create_filename(outdir, MODEL_FILE).c_str());
        } else {
          Rcpp::Rcout << create_filename(dicdir, MODEL_DEF_FILE)
                      << " is not found. skipped." << std::endl;
        }
      }

      if (opt_sysdic) {
        CHECK_DIE(dic.size()) << "no dictionaries are specified";
        param.set("type", static_cast<int>(MECAB_SYS_DIC));
        Dictionary::compile(param, dic,
                            create_filename(outdir, SYS_DIC_FILE).c_str());
      }

      if (opt_matrix) {
        Connector::compile(create_filename(dicdir, MATRIX_DEF_FILE).c_str(),
                           create_filename(outdir, MATRIX_FILE).c_str());
      }
    }

    Rcpp::Rcout << "\ndone!" << "\n";

    return 0;
  }
};

// #undef DCONF
// #undef OCONF
}  // namespace MeCab

//' Build system dictionary
//'
//' @param dic_dir Directory where the source dictionaries are located.
//' This argument is passed as '-d' option argument.
//' @param out_dir Directory where the binary dictionary will be written.
//' This argument is passed as '-o' option argument.
//' @param encoding Encoding of input csv files.
//' This argument is passed as '-f' option argument.
//' @returns Logical.
//' @name dict_index_sys
//' @keywords internal
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
bool dict_index_sys(const std::string& dic_dir, const std::string& out_dir,
                    const std::string& encoding) {
  std::vector<std::string> args;
  args.push_back("mecab-dict-index");
  if (dic_dir != "") {
    args.push_back("-d");
    args.push_back(dic_dir);
  }
  if (out_dir != "") {
    args.push_back("-o");
    args.push_back(out_dir);
  }
  args.push_back("-f");  // assume charset of input CSVs as ENC
  args.push_back(encoding);
  args.push_back("-t");  // make charset of binary dictionary ENC
  args.push_back("utf8");
  args.push_back("-s");
  args.push_back("-U");
  args.push_back("-C");
  args.push_back("--build-matrix");

  int argc = args.size();
  char** ptr = (char**)malloc(argc * sizeof(char*));
  for (int i = 0; i < argc; ++i) {
    ptr[i] = const_cast<char*>(args[i].c_str());
  }

  int ret;
  try {
    ret = MeCab::DictionaryComplier::run(argc, ptr);
  } catch (const std::exception& e) {
    Rcpp::Rcerr << e.what() << "\n";
    free(ptr);
    return false;
  }
  free(ptr);
  return ret == 0;
}

//' Build user dictionary
//'
//' @param dic_dir Directory where the source dictionaries are located.
//' This argument is passed as '-d' option argument.
//' @param file Path to write the user dictionary.
//' This argument is passed as '-u' option argument.
//' @param csv_file Path to an input csv file.
//' @param encoding Encoding of input csv files.
//' This argument is passed as '-f' option argument.
//' @returns Logical.
//' @name dict_index_user
//' @keywords internal
//
// [[Rcpp::interfaces(r, cpp)]]
// [[Rcpp::export]]
bool dict_index_user(const std::string& dic_dir, const std::string& file,
                     const std::string& csv_file, const std::string& encoding) {
  std::vector<std::string> args;
  args.push_back("mecab-dict-index");
  if (dic_dir != "") {
    args.push_back("-d");
    args.push_back(dic_dir);
  }
  if (file != "") {
    args.push_back("-u");
    args.push_back(file);
  }
  args.push_back("-f");
  args.push_back(encoding);
  args.push_back("-t");
  args.push_back("utf8");
  args.push_back(csv_file);

  int argc = args.size();
  char** ptr = (char**)malloc(argc * sizeof(char*));
  for (int i = 0; i < argc; ++i) {
    ptr[i] = const_cast<char*>(args[i].c_str());
  }

  int ret;
  try {
    ret = MeCab::DictionaryComplier::run(argc, ptr);
  } catch (const std::exception& e) {
    Rcpp::Rcerr << e.what() << "\n";
    free(ptr);
    return false;
  }
  free(ptr);
  return ret == 0;
}
