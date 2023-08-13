grammar bogus_scoped_table;

imports edu:umn:cs:melt:ableC:abstractsyntax:host as abs;

imports silver:langutil;
imports silver:langutil:pp;

abstract production table_thing
top::abs:Expr ::= x::abs:Expr y::abs:Expr z::abs:Expr
{
  top.pp = ppConcat([ text("table"), space(), x.pp, space(), y.pp, space(), z.pp ]);

  forwards to abs:addExpr(x, abs:addExpr(y, z));
}


