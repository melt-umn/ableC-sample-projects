grammar bogus_table;

imports edu:umn:cs:melt:ableC:abstractsyntax as abs;

imports silver:langutil;
imports silver:langutil:pp;

abstract production table_thing
top::abs:Expr ::= x::abs:Expr y::abs:Expr z::abs:Expr
{
  top.pp = ppConcat([ text("table"), space(), x.pp, space(), y.pp, space(), z.pp ]);

  local attribute op::abs:BinOp = abs:numOp(abs:addOp(location=top.location),location=top.location);

  forwards to abs:binaryOpExpr(x, op, abs:binaryOpExpr(y, op, z, location=top.location), location=top.location);
}


