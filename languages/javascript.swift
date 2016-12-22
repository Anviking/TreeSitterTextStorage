

public enum Javascript: UInt16 {
    case anon_sym_export = 1
    case anon_sym_STAR = 2
    case anon_sym_SEMI = 3
    case anon_sym_default = 4
    case anon_sym_LBRACE = 5
    case anon_sym_COMMA = 6
    case anon_sym_RBRACE = 7
    case anon_sym_as = 8
    case anon_sym_import = 9
    case anon_sym_from = 10
    case anon_sym_var = 11
    case anon_sym_let = 12
    case anon_sym_const = 13
    case anon_sym_if = 14
    case anon_sym_else = 15
    case anon_sym_switch = 16
    case anon_sym_LPAREN = 17
    case anon_sym_RPAREN = 18
    case anon_sym_for = 19
    case anon_sym_in = 20
    case anon_sym_of = 21
    case anon_sym_while = 22
    case anon_sym_do = 23
    case anon_sym_try = 24
    case anon_sym_break = 25
    case anon_sym_continue = 26
    case anon_sym_return = 27
    case anon_sym_yield = 28
    case anon_sym_throw = 29
    case anon_sym_case = 30
    case anon_sym_COLON = 31
    case anon_sym_catch = 32
    case anon_sym_finally = 33
    case anon_sym_EQ = 34
    case anon_sym_LBRACK = 35
    case anon_sym_RBRACK = 36
    case anon_sym_class = 37
    case anon_sym_extends = 38
    case anon_sym_async = 39
    case anon_sym_function = 40
    case anon_sym_EQ_GT = 41
    case anon_sym_new = 42
    case anon_sym_await = 43
    case anon_sym_DOT = 44
    case anon_sym_PLUS_EQ = 45
    case anon_sym_DASH_EQ = 46
    case anon_sym_STAR_EQ = 47
    case anon_sym_SLASH_EQ = 48
    case anon_sym_CARET_EQ = 49
    case anon_sym_DOT_DOT_DOT = 50
    case anon_sym_QMARK = 51
    case anon_sym_BANG = 52
    case anon_sym_AMP_AMP = 53
    case anon_sym_PIPE_PIPE = 54
    case anon_sym_TILDE = 55
    case anon_sym_GT_GT = 56
    case anon_sym_LT_LT = 57
    case anon_sym_AMP = 58
    case anon_sym_CARET = 59
    case anon_sym_PIPE = 60
    case anon_sym_DASH = 61
    case anon_sym_PLUS = 62
    case anon_sym_PLUS_PLUS = 63
    case anon_sym_DASH_DASH = 64
    case anon_sym_SLASH = 65
    case anon_sym_PERCENT = 66
    case anon_sym_delete = 67
    case anon_sym_void = 68
    case anon_sym_LT = 69
    case anon_sym_LT_EQ = 70
    case anon_sym_EQ_EQ = 71
    case anon_sym_EQ_EQ_EQ = 72
    case anon_sym_BANG_EQ = 73
    case anon_sym_BANG_EQ_EQ = 74
    case anon_sym_GT_EQ = 75
    case anon_sym_GT = 76
    case anon_sym_typeof = 77
    case anon_sym_instanceof = 78
    case sym_comment = 79
    case sym_string = 80
    case sym_template_string = 81
    case sym_regex = 82
    case sym_number = 83
    case sym_identifier = 84
    case sym_this_expression = 85
    case sym_super = 86
    case sym_true = 87
    case sym_false = 88
    case sym_null = 89
    case sym_undefined = 90
    case anon_sym_static = 91
    case anon_sym_get = 92
    case anon_sym_set = 93
    case sym__line_break = 94
    case sym_program = 95
    case sym__statements = 96
    case sym_export_statement = 97
    case sym_export_clause = 98
    case sym_export_specifier = 99
    case sym__declaration = 100
    case sym_import_statement = 101
    case sym_import_clause = 102
    case sym__from_clause = 103
    case sym_namespace_import = 104
    case sym_named_imports = 105
    case sym_import_specifier = 106
    case sym__statement = 107
    case sym__trailing_statement = 108
    case sym_expression_statement = 109
    case sym_trailing_expression_statement = 110
    case sym_var_declaration = 111
    case sym_trailing_var_declaration = 112
    case sym_statement_block = 113
    case sym_if_statement = 114
    case sym_trailing_if_statement = 115
    case sym_switch_statement = 116
    case sym_for_statement = 117
    case sym_trailing_for_statement = 118
    case sym_for_in_statement = 119
    case sym_trailing_for_in_statement = 120
    case sym_for_of_statement = 121
    case sym_trailing_for_of_statement = 122
    case sym_while_statement = 123
    case sym_trailing_while_statement = 124
    case sym_do_statement = 125
    case sym_trailing_do_statement = 126
    case sym_try_statement = 127
    case sym_break_statement = 128
    case sym_trailing_break_statement = 129
    case sym_continue_statement = 130
    case sym_trailing_continue_statement = 131
    case sym_return_statement = 132
    case sym_trailing_return_statement = 133
    case sym_yield_statement = 134
    case sym_trailing_yield_statement = 135
    case sym_throw_statement = 136
    case sym_trailing_throw_statement = 137
    case sym_empty_statement = 138
    case sym_case = 139
    case sym_default = 140
    case sym_catch = 141
    case sym_finally = 142
    case sym_var_assignment = 143
    case sym__paren_expression = 144
    case sym__expression = 145
    case sym_object = 146
    case sym__property_definition_list = 147
    case sym_array = 148
    case sym__element_list = 149
    case sym_anonymous_class = 150
    case sym_class = 151
    case sym__class_tail = 152
    case sym_function = 153
    case sym_arrow_function = 154
    case sym_generator_function = 155
    case sym_function_call = 156
    case sym_new_expression = 157
    case sym_await_expression = 158
    case sym_member_access = 159
    case sym_subscript_access = 160
    case sym_assignment = 161
    case sym_math_assignment = 162
    case sym_assignment_pattern = 163
    case sym_spread_element = 164
    case sym_ternary = 165
    case sym_bool_op = 166
    case sym_bitwise_op = 167
    case sym_math_op = 168
    case sym_delete_op = 169
    case sym_void_op = 170
    case sym_comma_op = 171
    case sym_rel_op = 172
    case sym_type_op = 173
    case sym_arguments = 174
    case sym_class_body = 175
    case sym_formal_parameters = 176
    case sym_method_definition = 177
    case sym_pair = 178
    case sym_reserved_identifier = 179
    case aux_sym_export_clause_repeat1 = 180
    case aux_sym_named_imports_repeat1 = 181
    case aux_sym_var_declaration_repeat1 = 182
    case aux_sym_switch_statement_repeat1 = 183
    case aux_sym_for_statement_repeat1 = 184
    case aux_sym_class_body_repeat1 = 185
    case aux_sym_formal_parameters_repeat1 = 186
};
