#include "tree_sitter/parser.h"

#define STATE_COUNT 20
#define SYMBOL_COUNT 12

enum {
    sym_expression = ts_builtin_sym_start,
    sym_sum,
    sym_product,
    anon_sym_LPAREN,
    anon_sym_RPAREN,
    anon_sym_PLUS,
    anon_sym_STAR,
    sym_number,
    sym_comment,
    sym_variable,
};

static const char *ts_symbol_names[] = {
    [sym_expression] = "expression",
    [sym_sum] = "sum",
    [sym_product] = "product",
    [ts_builtin_sym_error] = "ERROR",
    [ts_builtin_sym_end] = "END",
    [anon_sym_LPAREN] = "(",
    [anon_sym_RPAREN] = ")",
    [anon_sym_PLUS] = "+",
    [anon_sym_STAR] = "*",
    [sym_number] = "number",
    [sym_comment] = "comment",
    [sym_variable] = "variable",
};

static const TSSymbolMetadata ts_symbol_metadata[SYMBOL_COUNT] = {
    [sym_expression] = {.visible = true, .named = true, .structural = true, .extra = false},
    [sym_sum] = {.visible = true, .named = true, .structural = true, .extra = false},
    [sym_product] = {.visible = true, .named = true, .structural = true, .extra = false},
    [ts_builtin_sym_error] = {.visible = true, .named = true, .structural = true, .extra = false},
    [ts_builtin_sym_end] = {.visible = false, .named = false, .structural = true, .extra = false},
    [anon_sym_LPAREN] = {.visible = true, .named = false, .structural = true, .extra = false},
    [anon_sym_RPAREN] = {.visible = true, .named = false, .structural = true, .extra = false},
    [anon_sym_PLUS] = {.visible = true, .named = false, .structural = true, .extra = false},
    [anon_sym_STAR] = {.visible = true, .named = false, .structural = true, .extra = false},
    [sym_number] = {.visible = true, .named = true, .structural = true, .extra = false},
    [sym_comment] = {.visible = true, .named = true, .structural = false, .extra = true},
    [sym_variable] = {.visible = true, .named = true, .structural = true, .extra = false},
};

static TSTree *ts_lex(TSLexer *lexer, TSStateId state, bool error_mode) {
    START_LEXER();
    switch (state) {
        case 0:
            START_TOKEN();
            if (lookahead == 0)
                ADVANCE(1);
            if ((lookahead == '\t') ||
                (lookahead == '\n') ||
                (lookahead == '\r') ||
                (lookahead == ' '))
                ADVANCE(0);
            if (lookahead == '#')
                ADVANCE(2);
            if (lookahead == '(')
                ADVANCE(3);
            if (lookahead == ')')
                ADVANCE(4);
            if (lookahead == '*')
                ADVANCE(5);
            if (lookahead == '+')
                ADVANCE(6);
            if ('0' <= lookahead && lookahead <= '9')
                ADVANCE(7);
            if (('A' <= lookahead && lookahead <= 'Z') ||
                ('a' <= lookahead && lookahead <= 'z'))
                ADVANCE(8);
            LEX_ERROR();
        case 1:
            ACCEPT_TOKEN(ts_builtin_sym_end);
        case 2:
            if (!((lookahead == 0) ||
                (lookahead == '\n')))
                ADVANCE(2);
            ACCEPT_TOKEN(sym_comment);
        case 3:
            ACCEPT_TOKEN(anon_sym_LPAREN);
        case 4:
            ACCEPT_TOKEN(anon_sym_RPAREN);
        case 5:
            ACCEPT_TOKEN(anon_sym_STAR);
        case 6:
            ACCEPT_TOKEN(anon_sym_PLUS);
        case 7:
            if ('0' <= lookahead && lookahead <= '9')
                ADVANCE(7);
            ACCEPT_TOKEN(sym_number);
        case 8:
            if (('0' <= lookahead && lookahead <= '9') ||
                ('A' <= lookahead && lookahead <= 'Z') ||
                (lookahead == '_') ||
                ('a' <= lookahead && lookahead <= 'z'))
                ADVANCE(8);
            ACCEPT_TOKEN(sym_variable);
        case 9:
            START_TOKEN();
            if ((lookahead == '\t') ||
                (lookahead == '\n') ||
                (lookahead == '\r') ||
                (lookahead == ' '))
                ADVANCE(9);
            if (lookahead == '#')
                ADVANCE(2);
            if (lookahead == '(')
                ADVANCE(3);
            if ('0' <= lookahead && lookahead <= '9')
                ADVANCE(7);
            if (('A' <= lookahead && lookahead <= 'Z') ||
                ('a' <= lookahead && lookahead <= 'z'))
                ADVANCE(8);
            LEX_ERROR();
        case 10:
            START_TOKEN();
            if (lookahead == 0)
                ADVANCE(1);
            if ((lookahead == '\t') ||
                (lookahead == '\n') ||
                (lookahead == '\r') ||
                (lookahead == ' '))
                ADVANCE(10);
            if (lookahead == '#')
                ADVANCE(2);
            if (lookahead == '*')
                ADVANCE(5);
            if (lookahead == '+')
                ADVANCE(6);
            LEX_ERROR();
        case 11:
            START_TOKEN();
            if ((lookahead == '\t') ||
                (lookahead == '\n') ||
                (lookahead == '\r') ||
                (lookahead == ' '))
                ADVANCE(11);
            if (lookahead == '#')
                ADVANCE(2);
            if (lookahead == ')')
                ADVANCE(4);
            if (lookahead == '*')
                ADVANCE(5);
            if (lookahead == '+')
                ADVANCE(6);
            LEX_ERROR();
        case 12:
            START_TOKEN();
            if ((lookahead == '\t') ||
                (lookahead == '\n') ||
                (lookahead == '\r') ||
                (lookahead == ' '))
                ADVANCE(12);
            if (lookahead == '#')
                ADVANCE(2);
            if (lookahead == ')')
                ADVANCE(4);
            LEX_ERROR();
        default:
            LEX_ERROR();
    }
}

static TSStateId ts_lex_states[STATE_COUNT] = {
    [0] = 9,
    [1] = 10,
    [2] = 10,
    [3] = 9,
    [4] = 11,
    [5] = 11,
    [6] = 12,
    [7] = 9,
    [8] = 11,
    [9] = 12,
    [10] = 11,
    [11] = 9,
    [12] = 9,
    [13] = 11,
    [14] = 11,
    [15] = 10,
    [16] = 9,
    [17] = 9,
    [18] = 10,
    [19] = 10,
};

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmissing-field-initializers"

static unsigned short ts_parse_table[STATE_COUNT][SYMBOL_COUNT] = {
    [0] = {
        [sym_expression] = 2,
        [sym_sum] = 4,
        [sym_product] = 4,
        [anon_sym_LPAREN] = 6,
        [sym_number] = 4,
        [sym_comment] = 8,
        [sym_variable] = 4,
    },
    [1] = {
        [ts_builtin_sym_end] = 10,
        [anon_sym_PLUS] = 12,
        [anon_sym_STAR] = 14,
        [sym_comment] = 8,
    },
    [2] = {
        [ts_builtin_sym_end] = 16,
        [anon_sym_PLUS] = 16,
        [anon_sym_STAR] = 16,
        [sym_comment] = 8,
    },
    [3] = {
        [sym_expression] = 18,
        [sym_sum] = 20,
        [sym_product] = 20,
        [ts_builtin_sym_error] = 22,
        [anon_sym_LPAREN] = 24,
        [sym_number] = 20,
        [sym_comment] = 8,
        [sym_variable] = 20,
    },
    [4] = {
        [anon_sym_RPAREN] = 26,
        [anon_sym_PLUS] = 28,
        [anon_sym_STAR] = 30,
        [sym_comment] = 8,
    },
    [5] = {
        [anon_sym_RPAREN] = 16,
        [anon_sym_PLUS] = 16,
        [anon_sym_STAR] = 16,
        [sym_comment] = 8,
    },
    [6] = {
        [anon_sym_RPAREN] = 26,
        [sym_comment] = 8,
    },
    [7] = {
        [sym_expression] = 32,
        [sym_sum] = 20,
        [sym_product] = 20,
        [ts_builtin_sym_error] = 34,
        [anon_sym_LPAREN] = 24,
        [sym_number] = 20,
        [sym_comment] = 8,
        [sym_variable] = 20,
    },
    [8] = {
        [anon_sym_RPAREN] = 36,
        [anon_sym_PLUS] = 28,
        [anon_sym_STAR] = 30,
        [sym_comment] = 8,
    },
    [9] = {
        [anon_sym_RPAREN] = 36,
        [sym_comment] = 8,
    },
    [10] = {
        [anon_sym_RPAREN] = 38,
        [anon_sym_PLUS] = 38,
        [anon_sym_STAR] = 38,
        [sym_comment] = 8,
    },
    [11] = {
        [sym_expression] = 40,
        [sym_sum] = 20,
        [sym_product] = 20,
        [anon_sym_LPAREN] = 24,
        [sym_number] = 20,
        [sym_comment] = 8,
        [sym_variable] = 20,
    },
    [12] = {
        [sym_expression] = 42,
        [sym_sum] = 20,
        [sym_product] = 20,
        [anon_sym_LPAREN] = 24,
        [sym_number] = 20,
        [sym_comment] = 8,
        [sym_variable] = 20,
    },
    [13] = {
        [anon_sym_RPAREN] = 44,
        [anon_sym_PLUS] = 44,
        [anon_sym_STAR] = 44,
        [sym_comment] = 8,
    },
    [14] = {
        [anon_sym_RPAREN] = 46,
        [anon_sym_PLUS] = 46,
        [anon_sym_STAR] = 30,
        [sym_comment] = 8,
    },
    [15] = {
        [ts_builtin_sym_end] = 38,
        [anon_sym_PLUS] = 38,
        [anon_sym_STAR] = 38,
        [sym_comment] = 8,
    },
    [16] = {
        [sym_expression] = 48,
        [sym_sum] = 4,
        [sym_product] = 4,
        [anon_sym_LPAREN] = 6,
        [sym_number] = 4,
        [sym_comment] = 8,
        [sym_variable] = 4,
    },
    [17] = {
        [sym_expression] = 50,
        [sym_sum] = 4,
        [sym_product] = 4,
        [anon_sym_LPAREN] = 6,
        [sym_number] = 4,
        [sym_comment] = 8,
        [sym_variable] = 4,
    },
    [18] = {
        [ts_builtin_sym_end] = 44,
        [anon_sym_PLUS] = 44,
        [anon_sym_STAR] = 44,
        [sym_comment] = 8,
    },
    [19] = {
        [ts_builtin_sym_end] = 46,
        [anon_sym_PLUS] = 46,
        [anon_sym_STAR] = 14,
        [sym_comment] = 8,
    },
};

static TSParseActionEntry ts_parse_actions[] = {
    [0] = {.count = 1}, ERROR(),
    [2] = {.count = 1}, SHIFT(1, 0),
    [4] = {.count = 1}, SHIFT(2, 0),
    [6] = {.count = 1}, SHIFT(3, 0),
    [8] = {.count = 1}, SHIFT_EXTRA(),
    [10] = {.count = 1}, ACCEPT_INPUT(),
    [12] = {.count = 1}, SHIFT(16, 0),
    [14] = {.count = 1}, SHIFT(17, 0),
    [16] = {.count = 1}, REDUCE(sym_expression, 1, 0),
    [18] = {.count = 1}, SHIFT(4, 0),
    [20] = {.count = 1}, SHIFT(5, 0),
    [22] = {.count = 1}, SHIFT(6, 0),
    [24] = {.count = 1}, SHIFT(7, 0),
    [26] = {.count = 1}, SHIFT(15, 0),
    [28] = {.count = 1}, SHIFT(11, 0),
    [30] = {.count = 1}, SHIFT(12, 0),
    [32] = {.count = 1}, SHIFT(8, 0),
    [34] = {.count = 1}, SHIFT(9, 0),
    [36] = {.count = 1}, SHIFT(10, 0),
    [38] = {.count = 1}, REDUCE(sym_expression, 3, 0),
    [40] = {.count = 1}, SHIFT(14, 0),
    [42] = {.count = 1}, SHIFT(13, 0),
    [44] = {.count = 1}, REDUCE(sym_product, 3, 0),
    [46] = {.count = 1}, REDUCE(sym_sum, 3, FRAGILE),
    [48] = {.count = 1}, SHIFT(19, 0),
    [50] = {.count = 1}, SHIFT(18, 0),
};

#pragma GCC diagnostic pop

EXPORT_LANGUAGE(ts_language_arithmetic);

