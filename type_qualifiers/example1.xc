#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "string.xh"

struct Expr {
	enum {ADD, MUL, LITERAL} tag;
	union ExprVariant {
		struct {
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

int eval(check struct Expr * nonnull e)
{
	int val = 999;

	switch (e->tag) {
	case ADD:
		val = eval(e->variant.add.lhs) + eval(e->variant.add.rhs);
		break;
	case MUL:
		/* this would be a runtime error */
//		val = eval(e->variant.add.lhs) * eval(e->variant.add.rhs);
		val = eval(e->variant.mul.lhs) * eval(e->variant.mul.rhs);
		break;
	case LITERAL:
		val = e->variant.literal;
		break;
	};

	return val;
}

int fib(int n) <watch>
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
	/* this would be a runtime error */
//	e.variant.mul.lhs = &two_expr;

	printf("fib(2 + 3) = %d\n", fib(eval(&e)));

	return 0;
}

