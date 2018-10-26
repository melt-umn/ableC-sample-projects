#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "string.xh"

struct Expr {
	enum {ADD, MUL, LITERAL} tag;
	union ExprVariant {
		struct {
			/* A pointer annotated with the `nonnull` type qualifier
			 * may only be assigned values similarly qualified as
			 * nonnull. Attempting to assign a value not
			 * so-qualified will raise a compile-time error. */
			struct Expr * nonnull lhs;
			struct Expr * nonnull rhs;
		} add;
		struct {
			struct Expr * nonnull lhs;
			struct Expr * nonnull rhs;
		} mul;
		int literal;
	} variant;
};

/* Annotating struct Expr with the `check` type qualifier causes code to be
 * generated on each variant member access to ensure at runtime that the tag
 * matches the variant. */
int eval(check struct Expr * nonnull e)
{
	int val = 999;

	/* It is safe to dereference `e` without a runtime check because `e` is
	 * known at compile-time not to be null. */
	switch (e->tag) {
	case ADD:
		val = eval(e->variant.add.lhs) + eval(e->variant.add.rhs);
		break;
	case MUL:
		/* Attempting to access the `add` variant when the `tag` is MUL
		 * would result in a runtime error. */
//		val = eval(e->variant.add.lhs) * eval(e->variant.add.rhs);
		val = eval(e->variant.mul.lhs) * eval(e->variant.mul.rhs);
		break;
	case LITERAL:
		val = e->variant.literal;
		break;
	};

	return val;
}

/* Annotating a function with the `watch` type qualifier causes print statements
 * to be generated that display each call to the function and its arguments and
 * each exit from the function and its return value. */
int fib(int n) watch
{
	if (n < 2) {
		return n;
	} else {
		int x, y;
		x = fib(n-1);
		y = fib(n-2);
		return x + y;
	}
}

int main(void)
{
	check struct Expr two_expr = {LITERAL};
	two_expr.variant.literal = 2;

	check struct Expr three_expr = {LITERAL};
	three_expr.variant.literal = 3;

	check struct Expr e = {ADD};
	e.variant.add.lhs = &two_expr;
	e.variant.add.rhs = &three_expr;
	/* Attempting to assign to the `mul` variant when the `tag` is ADD would
	 * result in a runtime error. */
//	e.variant.mul.lhs = &two_expr;

	printf("fib(2 + 3) = %d\n", fib(eval(&e)));

	/* Attempting to pass a pointer not qualified as nonnull to eval will
	 * raise a compile-time error. */
//	struct Expr *p = &e;
//	eval(p);

	return 0;
}

