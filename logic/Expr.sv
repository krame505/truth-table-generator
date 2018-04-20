grammar logic;

imports silver:langutil;
imports silver:langutil:pp;

synthesized attribute components::[Decorated Expr];
synthesized attribute isBinary::Boolean;
inherited attribute isTopLevel::Boolean;
synthesized attribute vars::[String];

autocopy attribute assignment::[Pair<String Boolean>];
synthesized attribute value::Boolean;
synthesized attribute values::[Boolean];

nonterminal Expr with pps, components, isBinary, isTopLevel, vars, assignment, value, values;
flowtype Expr = decorate {isTopLevel};

abstract production varExpr
top::Expr ::= id::String
{
  top.pps = [text(id)];
  top.components = [top];
  top.isBinary = false;
  top.vars = [id];
  top.value = lookupBy(stringEq, id, top.assignment).fromJust;
  top.values = [top.value];
}

abstract production notExpr
top::Expr ::= e::Expr
{
  top.pps = pp"~" :: maybeWrapExprPPs(e);
  top.components = top :: e.components;
  top.isBinary = false;
  top.vars = e.vars;
  top.value = !e.value;
  top.values = top.value :: e.values;

  e.isTopLevel = false;
}

abstract production andExpr
top::Expr ::= e1::Expr e2::Expr
{
  top.pps = maybeWrapExprPPs(e1) ++ pp"&" :: maybeWrapExprPPs(e2);
  top.components = e1.components ++ top :: e2.components;
  top.isBinary = true;
  top.vars = unionBy(stringEq, e1.vars, e2.vars);
  top.value = e1.value && e2.value;
  top.values = e1.values ++ top.value :: e2.values;

  e1.isTopLevel = false;
  e2.isTopLevel = false;
}

abstract production orExpr
top::Expr ::= e1::Expr e2::Expr
{
  top.pps = maybeWrapExprPPs(e1) ++ pp"|" :: maybeWrapExprPPs(e2);
  top.components = e1.components ++ top :: e2.components;
  top.isBinary = true;
  top.vars = unionBy(stringEq, e1.vars, e2.vars);
  top.value = e1.value || e2.value;
  top.values = e1.values ++ top.value :: e2.values;

  e1.isTopLevel = false;
  e2.isTopLevel = false;
}

abstract production condExpr
top::Expr ::= e1::Expr e2::Expr
{
  top.pps = maybeWrapExprPPs(e1) ++ pp"=>" :: maybeWrapExprPPs(e2);
  top.components = e1.components ++ top :: e2.components;
  top.isBinary = true;
  top.vars = unionBy(stringEq, e1.vars, e2.vars);
  top.value = !e1.value || e2.value;
  top.values = e1.values ++ top.value :: e2.values;

  e1.isTopLevel = false;
  e2.isTopLevel = false;
}

abstract production bicondExpr
top::Expr ::= e1::Expr e2::Expr
{
  top.pps = maybeWrapExprPPs(e1) ++ pp"<=>" :: maybeWrapExprPPs(e2);
  top.components = e1.components ++ top :: e2.components;
  top.isBinary = true;
  top.vars = unionBy(stringEq, e1.vars, e2.vars);
  top.value = e1.value == e2.value;
  top.values = e1.values ++ top.value :: e2.values;

  e1.isTopLevel = false;
  e2.isTopLevel = false;
}

function maybeWrapExprPPs
[Document] ::= e::Decorated Expr
{
  return
    if e.isBinary
    then pp"[${head(e.pps)}" :: init(tail(e.pps)) ++ [pp"${last(e.pps)}]"]
    else e.pps;
}