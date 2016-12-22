#ifndef COMPILER_RULES_CHOICE_H_
#define COMPILER_RULES_CHOICE_H_

#include <string>
#include <vector>
#include "compiler/rule.h"

namespace tree_sitter {
namespace rules {

class Choice : public Rule {
 public:
  explicit Choice(const std::vector<rule_ptr> &elements);
  static rule_ptr build(const std::vector<rule_ptr> &rules);

  bool operator==(const Rule &other) const;
  size_t hash_code() const;
  rule_ptr copy() const;
  std::string to_string() const;
  void accept(Visitor *visitor) const;

  const std::vector<rule_ptr> elements;
};

}  // namespace rules
}  // namespace tree_sitter

#endif  // COMPILER_RULES_CHOICE_H_
