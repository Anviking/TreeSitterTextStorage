#ifndef RUNTIME_DOCUMENT_H_
#define RUNTIME_DOCUMENT_H_

#include "tparser.h"
#include "parser.h"
#include "tree.h"
#include <stdbool.h>

struct TSDocument {
  Parser parser;
  TSInput input;
  TSTree *tree;
  size_t parse_count;
  bool valid;
  bool owns_input;
};

#endif
