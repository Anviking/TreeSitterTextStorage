#include "compiler/rules/string.h"
#include <string>
#include "compiler/rules/visitor.h"

namespace tree_sitter {
namespace rules {

using std::string;
using std::hash;

String::String(string value) : value(value) {}

bool String::operator==(const Rule &rule) const {
  auto other = rule.as<String>();
  return other && (other->value == value);
}

size_t String::hash_code() const {
  return hash<string>()(value);
}

rule_ptr String::copy() const {
  return std::make_shared<String>(*this);
}

string String::to_string() const {
  return string("(string '") + value + "')";
}

void String::accept(Visitor *visitor) const {
  visitor->visit(this);
}

}  // namespace rules
}  // namespace tree_sitter
