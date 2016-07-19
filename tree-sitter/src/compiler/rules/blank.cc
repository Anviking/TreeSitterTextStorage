#include "compiler/rules/blank.h"
#include <string>
#include <memory>
#include "compiler/rules/visitor.h"

namespace tree_sitter {
namespace rules {

Blank::Blank() {}

rule_ptr Blank::build() {
  return std::make_shared<Blank>();
}

bool Blank::operator==(const Rule &rule) const {
  return rule.as<Blank>() != nullptr;
}

size_t Blank::hash_code() const {
  return 0;
}

rule_ptr Blank::copy() const {
  return std::make_shared<Blank>();
}

std::string Blank::to_string() const {
  return "(blank)";
}

void Blank::accept(Visitor *visitor) const {
  visitor->visit(this);
}

}  // namespace rules
}  // namespace tree_sitter
