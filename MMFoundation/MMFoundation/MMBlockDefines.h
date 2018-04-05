/**
 * Macros for metaprogramming
 * ExtendedC
 *
 * Copyright (C) 2012 Justin Spahr-Summers
 * Released under the MIT license
 */

/**
 * Executes one or more expressions (which may have a void type, such as a call
 * to a function that returns no value) and always returns true.
 */
#define mm_exprify(...) \
    ((__VA_ARGS__), true)

/**
 * Returns a string representation of VALUE after full macro expansion.
 */
#define mm_stringify(VALUE) \
        mm_stringify_(VALUE)

/**
 * Returns A and B concatenated after full macro expansion.
 */
#define mm_concat(A, B) \
        mm_concat_(A, B)

/**
 * Returns the Nth variadic argument (starting from zero). At least
 * N + 1 variadic arguments must be given. N must be between zero and twenty,
 * inclusive.
 */
#define mm_at(N, ...) \
        mm_concat(mm_at, N)(__VA_ARGS__)

/**
 * Returns the number of arguments (up to twenty) provided to the macro. At
 * least one argument must be provided.
 *
 * Inspired by P99: http://p99.gforge.inria.fr
 */
#define mm_argcount(...) \
        mm_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

/**
 * Identical to #mm_foreach_cxt, except that no CONTEXT argument is
 * given. Only the index and current argument will thus be passed to MACRO.
 */
#define mm_foreach(MACRO, SEP, ...) \
        mm_foreach_cxt(mm_foreach_iter, SEP, MACRO, __VA_ARGS__)

/**
 * For each consecutive variadic argument (up to twenty), MACRO is passed the
 * zero-based index of the current argument, CONTEXT, and then the argument
 * itself. The results of adjoining invocations of MACRO are then separated by
 * SEP.
 *
 * Inspired by P99: http://p99.gforge.inria.fr
 */
#define mm_foreach_cxt(MACRO, SEP, CONTEXT, ...) \
        mm_concat(mm_foreach_cxt, mm_argcount(__VA_ARGS__))(MACRO, SEP, CONTEXT, __VA_ARGS__)

/**
 * Identical to #mm_foreach_cxt. This can be used when the former would
 * fail due to recursive macro expansion.
 */
#define mm_foreach_cxt_recursive(MACRO, SEP, CONTEXT, ...) \
        mm_concat(mm_foreach_cxt_recursive, mm_argcount(__VA_ARGS__))(MACRO, SEP, CONTEXT, __VA_ARGS__)

/**
 * In consecutive order, appends each variadic argument (up to twenty) onto
 * BASE. The resulting concatenations are then separated by SEP.
 *
 * This is primarily useful to manipulate a list of macro invocations into instead
 * invoking a different, possibly related macro.
 */
#define mm_foreach_concat(BASE, SEP, ...) \
        mm_foreach_cxt(mm_foreach_concat_iter, SEP, BASE, __VA_ARGS__)

/**
 * Iterates COUNT times, each time invoking MACRO with the current index
 * (starting at zero) and CONTEXT. The results of adjoining invocations of MACRO
 * are then separated by SEP.
 *
 * COUNT must be an integer between zero and twenty, inclusive.
 */
#define mm_for_cxt(COUNT, MACRO, SEP, CONTEXT) \
        mm_concat(mm_for_cxt, COUNT)(MACRO, SEP, CONTEXT)

/**
 * Returns the first argument given. At least one argument must be provided.
 *
 * This is useful when implementing a variadic macro, where you may have only
 * one variadic argument, but no way to retrieve it (for example, because \c ...
 * always needs to match at least one argument).
 *
 * @code

#define varmacro(...) \
    mm_head(__VA_ARGS__)

 * @endcode
 */
#define mm_head(...) \
        mm_head_(__VA_ARGS__, 0)

/**
 * Returns every argument except the first. At least two arguments must be
 * provided.
 */
#define mm_tail(...) \
        mm_tail_(__VA_ARGS__)

/**
 * Returns the first N (up to twenty) variadic arguments as a new argument list.
 * At least N variadic arguments must be provided.
 */
#define mm_take(N, ...) \
        mm_concat(mm_take, N)(__VA_ARGS__)

/**
 * Removes the first N (up to twenty) variadic arguments from the given argument
 * list. At least N variadic arguments must be provided.
 */
#define mm_drop(N, ...) \
        mm_concat(mm_drop, N)(__VA_ARGS__)

/**
 * Decrements VAL, which must be a number between zero and twenty, inclusive.
 *
 * This is primarily useful when dealing with indexes and counts in
 * metaprogramming.
 */
#define mm_dec(VAL) \
        mm_at(VAL, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

/**
 * Increments VAL, which must be a number between zero and twenty, inclusive.
 *
 * This is primarily useful when dealing with indexes and counts in
 * metaprogramming.
 */
#define mm_inc(VAL) \
        mm_at(VAL, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21)

/**
 * If A is equal to B, the next argument list is expanded; otherwise, the
 * argument list after that is expanded. A and B must be numbers between zero
 * and twenty, inclusive. Additionally, B must be greater than or equal to A.
 *
 * @code

// expands to true
mm_if_eq(0, 0)(true)(false)

// expands to false
mm_if_eq(0, 1)(true)(false)

 * @endcode
 *
 * This is primarily useful when dealing with indexes and counts in
 * metaprogramming.
 */
#define mm_if_eq(A, B) \
        mm_concat(mm_if_eq, A)(B)

/**
 * Identical to #mm_if_eq. This can be used when the former would fail
 * due to recursive macro expansion.
 */
#define mm_if_eq_recursive(A, B) \
        mm_concat(mm_if_eq_recursive, A)(B)

/**
 * Returns 1 if N is an even number, or 0 otherwise. N must be between zero and
 * twenty, inclusive.
 *
 * For the purposes of this test, zero is considered even.
 */
#define mm_is_even(N) \
        mm_at(N, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1)

/**
 * Returns the logical NOT of B, which must be the number zero or one.
 */
#define mm_not(B) \
        mm_at(B, 1, 0)

// IMPLEMENTATION DETAILS FOLLOW!
// Do not write code that depends on anything below this line.
#define mm_stringify_(VALUE) # VALUE
#define mm_concat_(A, B) A ## B
#define mm_foreach_iter(INDEX, MACRO, ARG) MACRO(INDEX, ARG)
#define mm_head_(FIRST, ...) FIRST
#define mm_tail_(FIRST, ...) __VA_ARGS__
#define mm_consume_(...)
#define mm_expand_(...) __VA_ARGS__

// implemented from scratch so that mm_concat() doesn't end up nesting
#define mm_foreach_concat_iter(INDEX, BASE, ARG) mm_foreach_concat_iter_(BASE, ARG)
#define mm_foreach_concat_iter_(BASE, ARG) BASE ## ARG

// mm_at expansions
#define mm_at0(...) mm_head(__VA_ARGS__)
#define mm_at1(_0, ...) mm_head(__VA_ARGS__)
#define mm_at2(_0, _1, ...) mm_head(__VA_ARGS__)
#define mm_at3(_0, _1, _2, ...) mm_head(__VA_ARGS__)
#define mm_at4(_0, _1, _2, _3, ...) mm_head(__VA_ARGS__)
#define mm_at5(_0, _1, _2, _3, _4, ...) mm_head(__VA_ARGS__)
#define mm_at6(_0, _1, _2, _3, _4, _5, ...) mm_head(__VA_ARGS__)
#define mm_at7(_0, _1, _2, _3, _4, _5, _6, ...) mm_head(__VA_ARGS__)
#define mm_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...) mm_head(__VA_ARGS__)
#define mm_at9(_0, _1, _2, _3, _4, _5, _6, _7, _8, ...) mm_head(__VA_ARGS__)
#define mm_at10(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, ...) mm_head(__VA_ARGS__)
#define mm_at11(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, ...) mm_head(__VA_ARGS__)
#define mm_at12(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, ...) mm_head(__VA_ARGS__)
#define mm_at13(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, ...) mm_head(__VA_ARGS__)
#define mm_at14(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, ...) mm_head(__VA_ARGS__)
#define mm_at15(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, ...) mm_head(__VA_ARGS__)
#define mm_at16(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, ...) mm_head(__VA_ARGS__)
#define mm_at17(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, ...) mm_head(__VA_ARGS__)
#define mm_at18(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, ...) mm_head(__VA_ARGS__)
#define mm_at19(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, ...) mm_head(__VA_ARGS__)
#define mm_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) mm_head(__VA_ARGS__)

// mm_foreach_cxt expansions
#define mm_foreach_cxt0(MACRO, SEP, CONTEXT)
#define mm_foreach_cxt1(MACRO, SEP, CONTEXT, _0) MACRO(0, CONTEXT, _0)

#define mm_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
    mm_foreach_cxt1(MACRO, SEP, CONTEXT, _0) \
    SEP \
    MACRO(1, CONTEXT, _1)

#define mm_foreach_cxt3(MACRO, SEP, CONTEXT, _0, _1, _2) \
    mm_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
    SEP \
    MACRO(2, CONTEXT, _2)

#define mm_foreach_cxt4(MACRO, SEP, CONTEXT, _0, _1, _2, _3) \
    mm_foreach_cxt3(MACRO, SEP, CONTEXT, _0, _1, _2) \
    SEP \
    MACRO(3, CONTEXT, _3)

#define mm_foreach_cxt5(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4) \
    mm_foreach_cxt4(MACRO, SEP, CONTEXT, _0, _1, _2, _3) \
    SEP \
    MACRO(4, CONTEXT, _4)

#define mm_foreach_cxt6(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5) \
    mm_foreach_cxt5(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4) \
    SEP \
    MACRO(5, CONTEXT, _5)

#define mm_foreach_cxt7(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6) \
    mm_foreach_cxt6(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5) \
    SEP \
    MACRO(6, CONTEXT, _6)

#define mm_foreach_cxt8(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7) \
    mm_foreach_cxt7(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6) \
    SEP \
    MACRO(7, CONTEXT, _7)

#define mm_foreach_cxt9(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
    mm_foreach_cxt8(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7) \
    SEP \
    MACRO(8, CONTEXT, _8)

#define mm_foreach_cxt10(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
    mm_foreach_cxt9(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
    SEP \
    MACRO(9, CONTEXT, _9)

#define mm_foreach_cxt11(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
    mm_foreach_cxt10(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
    SEP \
    MACRO(10, CONTEXT, _10)

#define mm_foreach_cxt12(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
    mm_foreach_cxt11(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
    SEP \
    MACRO(11, CONTEXT, _11)

#define mm_foreach_cxt13(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
    mm_foreach_cxt12(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
    SEP \
    MACRO(12, CONTEXT, _12)

#define mm_foreach_cxt14(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
    mm_foreach_cxt13(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
    SEP \
    MACRO(13, CONTEXT, _13)

#define mm_foreach_cxt15(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
    mm_foreach_cxt14(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
    SEP \
    MACRO(14, CONTEXT, _14)

#define mm_foreach_cxt16(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
    mm_foreach_cxt15(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
    SEP \
    MACRO(15, CONTEXT, _15)

#define mm_foreach_cxt17(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
    mm_foreach_cxt16(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
    SEP \
    MACRO(16, CONTEXT, _16)

#define mm_foreach_cxt18(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
    mm_foreach_cxt17(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
    SEP \
    MACRO(17, CONTEXT, _17)

#define mm_foreach_cxt19(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
    mm_foreach_cxt18(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
    SEP \
    MACRO(18, CONTEXT, _18)

#define mm_foreach_cxt20(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19) \
    mm_foreach_cxt19(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
    SEP \
    MACRO(19, CONTEXT, _19)

// mm_foreach_cxt_recursive expansions
#define mm_foreach_cxt_recursive0(MACRO, SEP, CONTEXT)
#define mm_foreach_cxt_recursive1(MACRO, SEP, CONTEXT, _0) MACRO(0, CONTEXT, _0)

#define mm_foreach_cxt_recursive2(MACRO, SEP, CONTEXT, _0, _1) \
    mm_foreach_cxt_recursive1(MACRO, SEP, CONTEXT, _0) \
    SEP \
    MACRO(1, CONTEXT, _1)

#define mm_foreach_cxt_recursive3(MACRO, SEP, CONTEXT, _0, _1, _2) \
    mm_foreach_cxt_recursive2(MACRO, SEP, CONTEXT, _0, _1) \
    SEP \
    MACRO(2, CONTEXT, _2)

#define mm_foreach_cxt_recursive4(MACRO, SEP, CONTEXT, _0, _1, _2, _3) \
    mm_foreach_cxt_recursive3(MACRO, SEP, CONTEXT, _0, _1, _2) \
    SEP \
    MACRO(3, CONTEXT, _3)

#define mm_foreach_cxt_recursive5(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4) \
    mm_foreach_cxt_recursive4(MACRO, SEP, CONTEXT, _0, _1, _2, _3) \
    SEP \
    MACRO(4, CONTEXT, _4)

#define mm_foreach_cxt_recursive6(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5) \
    mm_foreach_cxt_recursive5(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4) \
    SEP \
    MACRO(5, CONTEXT, _5)

#define mm_foreach_cxt_recursive7(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6) \
    mm_foreach_cxt_recursive6(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5) \
    SEP \
    MACRO(6, CONTEXT, _6)

#define mm_foreach_cxt_recursive8(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7) \
    mm_foreach_cxt_recursive7(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6) \
    SEP \
    MACRO(7, CONTEXT, _7)

#define mm_foreach_cxt_recursive9(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
    mm_foreach_cxt_recursive8(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7) \
    SEP \
    MACRO(8, CONTEXT, _8)

#define mm_foreach_cxt_recursive10(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
    mm_foreach_cxt_recursive9(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
    SEP \
    MACRO(9, CONTEXT, _9)

#define mm_foreach_cxt_recursive11(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
    mm_foreach_cxt_recursive10(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
    SEP \
    MACRO(10, CONTEXT, _10)

#define mm_foreach_cxt_recursive12(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
    mm_foreach_cxt_recursive11(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
    SEP \
    MACRO(11, CONTEXT, _11)

#define mm_foreach_cxt_recursive13(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
    mm_foreach_cxt_recursive12(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
    SEP \
    MACRO(12, CONTEXT, _12)

#define mm_foreach_cxt_recursive14(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
    mm_foreach_cxt_recursive13(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
    SEP \
    MACRO(13, CONTEXT, _13)

#define mm_foreach_cxt_recursive15(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
    mm_foreach_cxt_recursive14(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
    SEP \
    MACRO(14, CONTEXT, _14)

#define mm_foreach_cxt_recursive16(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
    mm_foreach_cxt_recursive15(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
    SEP \
    MACRO(15, CONTEXT, _15)

#define mm_foreach_cxt_recursive17(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
    mm_foreach_cxt_recursive16(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
    SEP \
    MACRO(16, CONTEXT, _16)

#define mm_foreach_cxt_recursive18(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
    mm_foreach_cxt_recursive17(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
    SEP \
    MACRO(17, CONTEXT, _17)

#define mm_foreach_cxt_recursive19(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
    mm_foreach_cxt_recursive18(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
    SEP \
    MACRO(18, CONTEXT, _18)

#define mm_foreach_cxt_recursive20(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19) \
    mm_foreach_cxt_recursive19(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
    SEP \
    MACRO(19, CONTEXT, _19)

// mm_for_cxt expansions
#define mm_for_cxt0(MACRO, SEP, CONTEXT)
#define mm_for_cxt1(MACRO, SEP, CONTEXT) MACRO(0, CONTEXT)

#define mm_for_cxt2(MACRO, SEP, CONTEXT) \
    mm_for_cxt1(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(1, CONTEXT)

#define mm_for_cxt3(MACRO, SEP, CONTEXT) \
    mm_for_cxt2(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(2, CONTEXT)

#define mm_for_cxt4(MACRO, SEP, CONTEXT) \
    mm_for_cxt3(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(3, CONTEXT)

#define mm_for_cxt5(MACRO, SEP, CONTEXT) \
    mm_for_cxt4(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(4, CONTEXT)

#define mm_for_cxt6(MACRO, SEP, CONTEXT) \
    mm_for_cxt5(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(5, CONTEXT)

#define mm_for_cxt7(MACRO, SEP, CONTEXT) \
    mm_for_cxt6(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(6, CONTEXT)

#define mm_for_cxt8(MACRO, SEP, CONTEXT) \
    mm_for_cxt7(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(7, CONTEXT)

#define mm_for_cxt9(MACRO, SEP, CONTEXT) \
    mm_for_cxt8(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(8, CONTEXT)

#define mm_for_cxt10(MACRO, SEP, CONTEXT) \
    mm_for_cxt9(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(9, CONTEXT)

#define mm_for_cxt11(MACRO, SEP, CONTEXT) \
    mm_for_cxt10(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(10, CONTEXT)

#define mm_for_cxt12(MACRO, SEP, CONTEXT) \
    mm_for_cxt11(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(11, CONTEXT)

#define mm_for_cxt13(MACRO, SEP, CONTEXT) \
    mm_for_cxt12(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(12, CONTEXT)

#define mm_for_cxt14(MACRO, SEP, CONTEXT) \
    mm_for_cxt13(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(13, CONTEXT)

#define mm_for_cxt15(MACRO, SEP, CONTEXT) \
    mm_for_cxt14(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(14, CONTEXT)

#define mm_for_cxt16(MACRO, SEP, CONTEXT) \
    mm_for_cxt15(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(15, CONTEXT)

#define mm_for_cxt17(MACRO, SEP, CONTEXT) \
    mm_for_cxt16(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(16, CONTEXT)

#define mm_for_cxt18(MACRO, SEP, CONTEXT) \
    mm_for_cxt17(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(17, CONTEXT)

#define mm_for_cxt19(MACRO, SEP, CONTEXT) \
    mm_for_cxt18(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(18, CONTEXT)

#define mm_for_cxt20(MACRO, SEP, CONTEXT) \
    mm_for_cxt19(MACRO, SEP, CONTEXT) \
    SEP \
    MACRO(19, CONTEXT)

// mm_if_eq expansions
#define mm_if_eq0(VALUE) \
    mm_concat(mm_if_eq0_, VALUE)

#define mm_if_eq0_0(...) __VA_ARGS__ mm_consume_
#define mm_if_eq0_1(...) mm_expand_
#define mm_if_eq0_2(...) mm_expand_
#define mm_if_eq0_3(...) mm_expand_
#define mm_if_eq0_4(...) mm_expand_
#define mm_if_eq0_5(...) mm_expand_
#define mm_if_eq0_6(...) mm_expand_
#define mm_if_eq0_7(...) mm_expand_
#define mm_if_eq0_8(...) mm_expand_
#define mm_if_eq0_9(...) mm_expand_
#define mm_if_eq0_10(...) mm_expand_
#define mm_if_eq0_11(...) mm_expand_
#define mm_if_eq0_12(...) mm_expand_
#define mm_if_eq0_13(...) mm_expand_
#define mm_if_eq0_14(...) mm_expand_
#define mm_if_eq0_15(...) mm_expand_
#define mm_if_eq0_16(...) mm_expand_
#define mm_if_eq0_17(...) mm_expand_
#define mm_if_eq0_18(...) mm_expand_
#define mm_if_eq0_19(...) mm_expand_
#define mm_if_eq0_20(...) mm_expand_

#define mm_if_eq1(VALUE) mm_if_eq0(mm_dec(VALUE))
#define mm_if_eq2(VALUE) mm_if_eq1(mm_dec(VALUE))
#define mm_if_eq3(VALUE) mm_if_eq2(mm_dec(VALUE))
#define mm_if_eq4(VALUE) mm_if_eq3(mm_dec(VALUE))
#define mm_if_eq5(VALUE) mm_if_eq4(mm_dec(VALUE))
#define mm_if_eq6(VALUE) mm_if_eq5(mm_dec(VALUE))
#define mm_if_eq7(VALUE) mm_if_eq6(mm_dec(VALUE))
#define mm_if_eq8(VALUE) mm_if_eq7(mm_dec(VALUE))
#define mm_if_eq9(VALUE) mm_if_eq8(mm_dec(VALUE))
#define mm_if_eq10(VALUE) mm_if_eq9(mm_dec(VALUE))
#define mm_if_eq11(VALUE) mm_if_eq10(mm_dec(VALUE))
#define mm_if_eq12(VALUE) mm_if_eq11(mm_dec(VALUE))
#define mm_if_eq13(VALUE) mm_if_eq12(mm_dec(VALUE))
#define mm_if_eq14(VALUE) mm_if_eq13(mm_dec(VALUE))
#define mm_if_eq15(VALUE) mm_if_eq14(mm_dec(VALUE))
#define mm_if_eq16(VALUE) mm_if_eq15(mm_dec(VALUE))
#define mm_if_eq17(VALUE) mm_if_eq16(mm_dec(VALUE))
#define mm_if_eq18(VALUE) mm_if_eq17(mm_dec(VALUE))
#define mm_if_eq19(VALUE) mm_if_eq18(mm_dec(VALUE))
#define mm_if_eq20(VALUE) mm_if_eq19(mm_dec(VALUE))

// mm_if_eq_recursive expansions
#define mm_if_eq_recursive0(VALUE) \
    mm_concat(mm_if_eq_recursive0_, VALUE)

#define mm_if_eq_recursive0_0(...) __VA_ARGS__ mm_consume_
#define mm_if_eq_recursive0_1(...) mm_expand_
#define mm_if_eq_recursive0_2(...) mm_expand_
#define mm_if_eq_recursive0_3(...) mm_expand_
#define mm_if_eq_recursive0_4(...) mm_expand_
#define mm_if_eq_recursive0_5(...) mm_expand_
#define mm_if_eq_recursive0_6(...) mm_expand_
#define mm_if_eq_recursive0_7(...) mm_expand_
#define mm_if_eq_recursive0_8(...) mm_expand_
#define mm_if_eq_recursive0_9(...) mm_expand_
#define mm_if_eq_recursive0_10(...) mm_expand_
#define mm_if_eq_recursive0_11(...) mm_expand_
#define mm_if_eq_recursive0_12(...) mm_expand_
#define mm_if_eq_recursive0_13(...) mm_expand_
#define mm_if_eq_recursive0_14(...) mm_expand_
#define mm_if_eq_recursive0_15(...) mm_expand_
#define mm_if_eq_recursive0_16(...) mm_expand_
#define mm_if_eq_recursive0_17(...) mm_expand_
#define mm_if_eq_recursive0_18(...) mm_expand_
#define mm_if_eq_recursive0_19(...) mm_expand_
#define mm_if_eq_recursive0_20(...) mm_expand_

#define mm_if_eq_recursive1(VALUE) mm_if_eq_recursive0(mm_dec(VALUE))
#define mm_if_eq_recursive2(VALUE) mm_if_eq_recursive1(mm_dec(VALUE))
#define mm_if_eq_recursive3(VALUE) mm_if_eq_recursive2(mm_dec(VALUE))
#define mm_if_eq_recursive4(VALUE) mm_if_eq_recursive3(mm_dec(VALUE))
#define mm_if_eq_recursive5(VALUE) mm_if_eq_recursive4(mm_dec(VALUE))
#define mm_if_eq_recursive6(VALUE) mm_if_eq_recursive5(mm_dec(VALUE))
#define mm_if_eq_recursive7(VALUE) mm_if_eq_recursive6(mm_dec(VALUE))
#define mm_if_eq_recursive8(VALUE) mm_if_eq_recursive7(mm_dec(VALUE))
#define mm_if_eq_recursive9(VALUE) mm_if_eq_recursive8(mm_dec(VALUE))
#define mm_if_eq_recursive10(VALUE) mm_if_eq_recursive9(mm_dec(VALUE))
#define mm_if_eq_recursive11(VALUE) mm_if_eq_recursive10(mm_dec(VALUE))
#define mm_if_eq_recursive12(VALUE) mm_if_eq_recursive11(mm_dec(VALUE))
#define mm_if_eq_recursive13(VALUE) mm_if_eq_recursive12(mm_dec(VALUE))
#define mm_if_eq_recursive14(VALUE) mm_if_eq_recursive13(mm_dec(VALUE))
#define mm_if_eq_recursive15(VALUE) mm_if_eq_recursive14(mm_dec(VALUE))
#define mm_if_eq_recursive16(VALUE) mm_if_eq_recursive15(mm_dec(VALUE))
#define mm_if_eq_recursive17(VALUE) mm_if_eq_recursive16(mm_dec(VALUE))
#define mm_if_eq_recursive18(VALUE) mm_if_eq_recursive17(mm_dec(VALUE))
#define mm_if_eq_recursive19(VALUE) mm_if_eq_recursive18(mm_dec(VALUE))
#define mm_if_eq_recursive20(VALUE) mm_if_eq_recursive19(mm_dec(VALUE))

// mm_take expansions
#define mm_take0(...)
#define mm_take1(...) mm_head(__VA_ARGS__)
#define mm_take2(...) mm_head(__VA_ARGS__), mm_take1(mm_tail(__VA_ARGS__))
#define mm_take3(...) mm_head(__VA_ARGS__), mm_take2(mm_tail(__VA_ARGS__))
#define mm_take4(...) mm_head(__VA_ARGS__), mm_take3(mm_tail(__VA_ARGS__))
#define mm_take5(...) mm_head(__VA_ARGS__), mm_take4(mm_tail(__VA_ARGS__))
#define mm_take6(...) mm_head(__VA_ARGS__), mm_take5(mm_tail(__VA_ARGS__))
#define mm_take7(...) mm_head(__VA_ARGS__), mm_take6(mm_tail(__VA_ARGS__))
#define mm_take8(...) mm_head(__VA_ARGS__), mm_take7(mm_tail(__VA_ARGS__))
#define mm_take9(...) mm_head(__VA_ARGS__), mm_take8(mm_tail(__VA_ARGS__))
#define mm_take10(...) mm_head(__VA_ARGS__), mm_take9(mm_tail(__VA_ARGS__))
#define mm_take11(...) mm_head(__VA_ARGS__), mm_take10(mm_tail(__VA_ARGS__))
#define mm_take12(...) mm_head(__VA_ARGS__), mm_take11(mm_tail(__VA_ARGS__))
#define mm_take13(...) mm_head(__VA_ARGS__), mm_take12(mm_tail(__VA_ARGS__))
#define mm_take14(...) mm_head(__VA_ARGS__), mm_take13(mm_tail(__VA_ARGS__))
#define mm_take15(...) mm_head(__VA_ARGS__), mm_take14(mm_tail(__VA_ARGS__))
#define mm_take16(...) mm_head(__VA_ARGS__), mm_take15(mm_tail(__VA_ARGS__))
#define mm_take17(...) mm_head(__VA_ARGS__), mm_take16(mm_tail(__VA_ARGS__))
#define mm_take18(...) mm_head(__VA_ARGS__), mm_take17(mm_tail(__VA_ARGS__))
#define mm_take19(...) mm_head(__VA_ARGS__), mm_take18(mm_tail(__VA_ARGS__))
#define mm_take20(...) mm_head(__VA_ARGS__), mm_take19(mm_tail(__VA_ARGS__))

// mm_drop expansions
#define mm_drop0(...) __VA_ARGS__
#define mm_drop1(...) mm_tail(__VA_ARGS__)
#define mm_drop2(...) mm_drop1(mm_tail(__VA_ARGS__))
#define mm_drop3(...) mm_drop2(mm_tail(__VA_ARGS__))
#define mm_drop4(...) mm_drop3(mm_tail(__VA_ARGS__))
#define mm_drop5(...) mm_drop4(mm_tail(__VA_ARGS__))
#define mm_drop6(...) mm_drop5(mm_tail(__VA_ARGS__))
#define mm_drop7(...) mm_drop6(mm_tail(__VA_ARGS__))
#define mm_drop8(...) mm_drop7(mm_tail(__VA_ARGS__))
#define mm_drop9(...) mm_drop8(mm_tail(__VA_ARGS__))
#define mm_drop10(...) mm_drop9(mm_tail(__VA_ARGS__))
#define mm_drop11(...) mm_drop10(mm_tail(__VA_ARGS__))
#define mm_drop12(...) mm_drop11(mm_tail(__VA_ARGS__))
#define mm_drop13(...) mm_drop12(mm_tail(__VA_ARGS__))
#define mm_drop14(...) mm_drop13(mm_tail(__VA_ARGS__))
#define mm_drop15(...) mm_drop14(mm_tail(__VA_ARGS__))
#define mm_drop16(...) mm_drop15(mm_tail(__VA_ARGS__))
#define mm_drop17(...) mm_drop16(mm_tail(__VA_ARGS__))
#define mm_drop18(...) mm_drop17(mm_tail(__VA_ARGS__))
#define mm_drop19(...) mm_drop18(mm_tail(__VA_ARGS__))
#define mm_drop20(...) mm_drop19(mm_tail(__VA_ARGS__))





/**
 * \@onExit defines some code to be executed when the current scope exits. The
 * code must be enclosed in braces and terminated with a semicolon, and will be
 * executed regardless of how the scope is exited, including from exceptions,
 * \c goto, \c return, \c break, and \c continue.
 *
 * Provided code will go into a block to be executed later. Keep this in mind as
 * it pertains to memory management, restrictions on assignment, etc. Because
 * the code is used within a block, \c return is a legal (though perhaps
 * confusing) way to exit the cleanup block early.
 *
 * Multiple \@onExit statements in the same scope are executed in reverse
 * lexical order. This helps when pairing resource acquisition with \@onExit
 * statements, as it guarantees teardown in the opposite order of acquisition.
 *
 * @note This statement cannot be used within scopes defined without braces
 * (like a one line \c if). In practice, this is not an issue, since \@onExit is
 * a useless construct in such a case anyways.
 */
#define onExit \
mm_keywordify \
__strong mm_cleanupBlock_t mm_concat(mm_exitBlock_, __LINE__) __attribute__((cleanup(mm_executeCleanupBlock), unused)) = ^

/**
 * Creates \c __weak shadow variables for each of the variables provided as
 * arguments, which can later be made strong again with #strongify.
 *
 * This is typically used to weakly reference variables in a block, but then
 * ensure that the variables stay alive during the actual execution of the block
 * (if they were live upon entry).
 *
 * See #strongify for an example of usage.
 */
#define weakify(...) \
mm_keywordify \
mm_foreach_cxt(mm_weakify_,, __weak, __VA_ARGS__)

/**
 * Like #weakify, but uses \c __unsafe_unretained instead, for targets or
 * classes that do not support weak references.
 */
#define unsafeify(...) \
mm_keywordify \
mm_foreach_cxt(mm_weakify_,, __unsafe_unretained, __VA_ARGS__)

/**
 * Strongly references each of the variables provided as arguments, which must
 * have previously been passed to #weakify.
 *
 * The strong references created will shadow the original variable names, such
 * that the original names can be used without issue (and a significantly
 * reduced risk of retain cycles) in the current scope.
 *
 * @code
 
 id foo = [[NSObject alloc] init];
 id bar = [[NSObject alloc] init];
 
 @weakify(foo, bar);
 
 // this block will not keep 'foo' or 'bar' alive
 BOOL (^matchesFooOrBar)(id) = ^ BOOL (id obj){
 // but now, upon entry, 'foo' and 'bar' will stay alive until the block has
 // finished executing
 @strongify(foo, bar);
 
 return [foo isEqual:obj] || [bar isEqual:obj];
 };
 
 * @endcode
 */
#define strongify(...) \
mm_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
mm_foreach(mm_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")

/*** implementation details follow ***/
typedef void (^mm_cleanupBlock_t)(void);

static inline void mm_executeCleanupBlock (__strong mm_cleanupBlock_t *block) {
    (*block)();
}

#define mm_weakify_(INDEX, CONTEXT, VAR) \
CONTEXT __typeof__(VAR) mm_concat(VAR, _weak_) = (VAR);

#define mm_strongify_(INDEX, VAR) \
__strong __typeof__(VAR) VAR = mm_concat(VAR, _weak_);

// Details about the choice of backing keyword:
//
// The use of @try/@catch/@finally can cause the compiler to suppress
// return-type warnings.
// The use of @autoreleasepool {} is not optimized away by the compiler,
// resulting in superfluous creation of autorelease pools.
//
// Since neither option is perfect, and with no other alternatives, the
// compromise is to use @autorelease in DEBUG builds to maintain compiler
// analysis, and to use @try/@catch otherwise to avoid insertion of unnecessary
// autorelease pools.
#if DEBUG
#define mm_keywordify autoreleasepool {}
#else
#define mm_keywordify try {} @catch (...) {}
#endif
