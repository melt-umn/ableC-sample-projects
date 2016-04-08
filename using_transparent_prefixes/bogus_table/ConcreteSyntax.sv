grammar bogus_table;

imports edu:umn:cs:melt:ableC:concretesyntax as cnc;

marking terminal TableKwd_t 'table' lexer classes {Ckeyword};

concrete production table_thing_c
top::cnc:PrimaryExpr_c ::= 'table' x::cnc:Constant_c ',' y::cnc:Constant_c ',' z::cnc:Constant_c
{
  top.ast = table_thing(x.ast, y.ast, z.ast, location=top.location);
}


