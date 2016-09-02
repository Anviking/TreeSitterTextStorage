//
//  Javascript.swift
//  TreeSitter
//
//  Created by Johannes Lund on 2016-07-07.
//  Copyright © 2016 Johannes Lund. All rights reserved.
//

import Foundation
import Language

public enum JavaScript: UInt16, LanguageSymbolProtocol {
    
    public static var languagePointer = ts_language_javascript()!
    
    public var tokenType: TokenType? {
        switch self {
        case .sym_string:
            return .string
        case .sym_comment:
            return .comment
        case .sym_number:
            return .number
        case .anon_sym_return, .anon_sym_while, .anon_sym_static, .anon_sym_const, .anon_sym_if, .anon_sym_else, .sym_class, .anon_sym_function, .anon_sym_var, .anon_sym_EQ_GT, .anon_sym_async, .anon_sym_await, .anon_sym_export:
            return .keyword
        case .sym_member_access:
            return .otherMethodNames
        default:
            return nil // Important to return nil to continue search in nested nodes
        }
    }
    
    case sym_program = 1
    case sym__statements = 2
    case sym_export_statement = 3
    case sym_export_clause = 4
    case sym_export_specifier = 5
    case sym__declaration = 6
    case sym_import_statement = 7
    case sym_import_clause = 8
    case sym__from_clause = 9
    case sym_namespace_import = 10
    case sym_named_imports = 11
    case sym_import_specifier = 12
    case sym__statement = 13
    case sym_expression_statement = 14
    case sym_trailing_expression_statement = 15
    case sym_var_declaration = 16
    case sym_statement_block = 17
    case sym_if_statement = 18
    case sym_switch_statement = 19
    case sym_for_statement = 20
    case sym_for_in_statement = 21
    case sym_for_of_statement = 22
    case sym_while_statement = 23
    case sym_do_statement = 24
    case sym_try_statement = 25
    case sym_break_statement = 26
    case sym_trailing_break_statement = 27
    case sym_return_statement = 28
    case sym_trailing_return_statement = 29
    case sym_yield_statement = 30
    case sym_trailing_yield_statement = 31
    case sym_throw_statement = 32
    case sym_trailing_throw_statement = 33
    case sym_empty_statement = 34
    case sym_case = 35
    case sym_default = 36
    case sym_catch = 37
    case sym_finally = 38
    case sym_var_assignment = 39
    case sym__paren_expression = 40
    case sym__expression = 41
    case sym_object = 42
    case sym_array = 43
    case sym_anonymous_class = 44
    case sym_class = 45
    case sym__class_tail = 46
    case sym_function = 47
    case sym_arrow_function = 48
    case sym_generator_function = 49
    case sym_function_call = 50
    case sym_new_expression = 51
    case sym_await_expression = 52
    case sym_member_access = 53
    case sym_subscript_access = 54
    case sym_assignment = 55
    case sym_math_assignment = 56
    case sym__assignment_pattern = 57
    case sym_object_assignment_pattern = 58
    case sym_array_assignment_pattern = 59
    case sym_assignment_property = 60
    case sym_assignment_rest_element = 61
    case sym_ternary = 62
    case sym_bool_op = 63
    case sym_bitwise_op = 64
    case sym_math_op = 65
    case sym_delete_op = 66
    case sym_void_op = 67
    case sym_comma_op = 68
    case sym_rel_op = 69
    case sym_type_op = 70
    case sym_arguments = 71
    case sym_class_body = 72
    case sym_formal_parameters = 73
    case sym_method_definition = 74
    case sym_pair = 75
    case sym_reserved_identifier = 76
    case aux_sym_export_clause_repeat1 = 77
    case aux_sym_named_imports_repeat1 = 78
    case aux_sym_var_declaration_repeat1 = 79
    case aux_sym_switch_statement_repeat1 = 80
    case aux_sym_for_statement_repeat1 = 81
    case aux_sym_object_repeat1 = 82
    case aux_sym_object_assignment_pattern_repeat1 = 83
    case aux_sym_array_assignment_pattern_repeat1 = 84
    case aux_sym_class_body_repeat1 = 85
    case aux_sym_formal_parameters_repeat1 = 86
    case anon_sym_export = 87
    case anon_sym_STAR = 88
    case anon_sym_SEMI = 89
    case anon_sym_default = 90
    case anon_sym_LBRACE = 91
    case anon_sym_COMMA = 92
    case anon_sym_RBRACE = 93
    case anon_sym_as = 94
    case anon_sym_import = 95
    case anon_sym_from = 96
    case anon_sym_var = 97
    case anon_sym_let = 98
    case anon_sym_const = 99
    case anon_sym_if = 100
    case anon_sym_else = 101
    case anon_sym_switch = 102
    case anon_sym_LPAREN = 103
    case anon_sym_RPAREN = 104
    case anon_sym_for = 105
    case anon_sym_in = 106
    case anon_sym_of = 107
    case anon_sym_while = 108
    case anon_sym_do = 109
    case anon_sym_try = 110
    case anon_sym_break = 111
    case anon_sym_return = 112
    case anon_sym_yield = 113
    case anon_sym_throw = 114
    case anon_sym_case = 115
    case anon_sym_COLON = 116
    case anon_sym_catch = 117
    case anon_sym_finally = 118
    case anon_sym_EQ = 119
    case anon_sym_LBRACK = 120
    case anon_sym_RBRACK = 121
    case anon_sym_class = 122
    case anon_sym_extends = 123
    case anon_sym_async = 124
    case anon_sym_function = 125
    case anon_sym_EQ_GT = 126
    case anon_sym_new = 127
    case anon_sym_await = 128
    case anon_sym_DOT = 129
    case anon_sym_PLUS_EQ = 130
    case anon_sym_DASH_EQ = 131
    case anon_sym_STAR_EQ = 132
    case anon_sym_SLASH_EQ = 133
    case anon_sym_DOT_DOT_DOT = 134
    case anon_sym_QMARK = 135
    case anon_sym_BANG = 136
    case anon_sym_AMP_AMP = 137
    case anon_sym_PIPE_PIPE = 138
    case anon_sym_TILDE = 139
    case anon_sym_GT_GT = 140
    case anon_sym_LT_LT = 141
    case anon_sym_AMP = 142
    case anon_sym_CARET = 143
    case anon_sym_PIPE = 144
    case anon_sym_DASH = 145
    case anon_sym_PLUS = 146
    case anon_sym_PLUS_PLUS = 147
    case anon_sym_DASH_DASH = 148
    case anon_sym_SLASH = 149
    case anon_sym_PERCENT = 150
    case anon_sym_delete = 151
    case anon_sym_void = 152
    case anon_sym_LT = 153
    case anon_sym_LT_EQ = 154
    case anon_sym_EQ_EQ = 155
    case anon_sym_EQ_EQ_EQ = 156
    case anon_sym_BANG_EQ = 157
    case anon_sym_BANG_EQ_EQ = 158
    case anon_sym_GT_EQ = 159
    case anon_sym_GT = 160
    case anon_sym_typeof = 161
    case anon_sym_instanceof = 162
    case sym_comment = 163
    case sym_string = 164
    case sym_template_string = 165
    case sym_regex = 166
    case sym_number = 167
    case sym_identifier = 168
    case sym_this_expression = 169
    case sym_super = 170
    case sym_true = 171
    case sym_false = 172
    case sym_null = 173
    case sym_undefined = 174
    case anon_sym_static = 175
    case anon_sym_get = 176
    case anon_sym_set = 177
    case sym__line_break = 178
}
