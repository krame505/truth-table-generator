grammar logic;

terminal Identifier_t /[A-Za-z_][A-Za-z_0-9]*/;

terminal Not_t    '~'   precedence=5;

terminal And_t    '&'   association=left, precedence=4;
terminal Or_t     '|'   association=left, precedence=3;
terminal Cond_t   '=>'  association=left, precedence=2;
terminal Bicond_t '<=>' association=left, precedence=1;

terminal LParen_t   '(';
terminal RParen_t   ')';
terminal LBracket_t '[';
terminal RBracket_t ']';

ignore terminal Whitespace_t /[\ \t\n\r]+/;

nonterminal Expr_c with ast<Expr>;

concrete productions top::Expr_c
| id::Identifier_t
  { top.ast = varExpr(id.lexeme); }
| '(' e::Expr_c ')'
  { top.ast = e.ast; }
| '[' e::Expr_c ']'
  { top.ast = e.ast; }
| '~' e::Expr_c
  { top.ast = notExpr(e.ast); }
| e1::Expr_c '&' e2::Expr_c
  { top.ast = andExpr(e1.ast, e2.ast); }
| e1::Expr_c '|' e2::Expr_c
  { top.ast = orExpr(e1.ast, e2.ast); }
| e1::Expr_c '=>' e2::Expr_c
  { top.ast = condExpr(e1.ast, e2.ast); }
| e1::Expr_c '<=>' e2::Expr_c
  { top.ast = bicondExpr(e1.ast, e2.ast); }