grammar bogus_table;

imports edu:umn:cs:melt:ableC:concretesyntax as cnc;

marking terminal TableKwd_t 'table' lexer classes {Keyword};

disambiguate TableKwd_t, cnc:Identifier_t {
  pluck TableKwd_t;
}

disambiguate TableKwd_t, cnc:Identifier_t, cnc:TypeName_t {
  pluck TableKwd_t;
}

concrete production table_thing_c
top::cnc:PrimaryExpr_c ::= 'table' x::cnc:Constant_c ',' y::cnc:Constant_c ',' z::cnc:Constant_c
{
  top.ast = table_thing(x.ast, y.ast, z.ast, location=top.location);
}


