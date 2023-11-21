//   MeCab -- Yet Another Part-of-Speech and Morphological Analyzer
//
//
//   Copyright(C) 2001-2006 Taku Kudo <taku@chasen.org>
//   Copyright(C) 2004-2006 Nippon Telegraph and Telephone Corporation
#ifndef MECAB_ICONV_H
#define MECAB_ICONV_H

#if defined HAVE_ICONV
#include <R_ext/Riconv.h>
#endif

#if defined(_WIN32) && !defined(__CYGWIN__)
#ifndef NOMINMAX
#define NOMINMAX 1
#endif
#include <windows.h>
#endif

namespace MeCab {

class Iconv {
 private:
#ifdef HAVE_ICONV
  void *ic_;
#else
  int ic_;
#endif

#if defined(_WIN32) && !defined(__CYGWIN__)
  DWORD from_cp_;
  DWORD to_cp_;
#endif

 public:
  explicit Iconv();
  virtual ~Iconv();
  bool open(const char *from, const char *to);
  bool convert(std::string *);
};
}  // namespace MeCab

#endif
