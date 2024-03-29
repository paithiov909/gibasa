//  MeCab -- Yet Another Part-of-Speech and Morphological Analyzer
//
//
//  Copyright(C) 2001-2006 Taku Kudo <taku@chasen.org>
//  Copyright(C) 2004-2006 Nippon Telegraph and Telephone Corporation
#ifndef MECAB_NBEST_GENERATOR_H_
#define MECAB_NBEST_GENERATOR_H_

#include <queue>

#include "freelist.h"
#include "mecab.h"

namespace MeCab {

class NBestGenerator {
 private:
  struct QueueElement {
    Node *node;
    QueueElement *next;
    long fx;  // f(x) = h(x) + g(x): cost function for A* search
    long gx;  // g(x)
  };

  class QueueElementComp {
   public:
    bool operator()(QueueElement *q1, QueueElement *q2) const {
      return (q1->fx > q2->fx);
    }
  };

  std::priority_queue<QueueElement *, std::vector<QueueElement *>,
                      QueueElementComp>
      agenda_;
  FreeList<QueueElement> freelist_;

 public:
  explicit NBestGenerator() : freelist_(512) {}
  virtual ~NBestGenerator() {}
  bool set(Lattice *lattice);
  bool next();
};
}  // namespace MeCab

#endif  // MECAB_NBEST_GENERATOR_H_
