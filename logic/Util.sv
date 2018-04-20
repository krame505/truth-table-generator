grammar logic;

import core:monad;

function possibleAssignments
[[Pair<String Boolean>]] ::= vars::[String]
{
  return
    foldr(
      \ var::String assignments::[[Pair<String Boolean>]] ->
        do (bindList, returnList) {
          assignment::[Pair<String Boolean>] <- assignments;
          val::Boolean <- [true, false];
          return pair(var, val) :: assignment;
        },
      [[]], vars);
}

function values
[Boolean] ::= e::Expr assignment::[Pair<String Boolean>]
{
  e.assignment = assignment;
  return e.values;
}

function truthTable
[[Boolean]] ::= e::Expr
{
  return map(values(e, _), possibleAssignments(e.vars));
}

function formatRow
String ::= e::Expr items::[String]
{
  e.isTopLevel = true;
  return
    implode(
      " | ",
      zipWith(
        \ item::String isTopLevel::Boolean ->
          substitute(
            "|", "\\|",
            substitute(
              "[", "\\[",
              if isTopLevel then s"**${item}**" else item)),
        items,
        map(\ component::Decorated Expr -> component.isTopLevel, e.components)));
}

function showTruthTable
String ::= e::Expr
{
  e.isTopLevel = true;
  return s"""
${formatRow(e, map(show(100, _), e.pps))}
${implode(" | ", repeat(":-:", length(e.components)))}
${implode(
    "\n",
     map(
       \ row::[Boolean] -> formatRow(e, map(\ b::Boolean -> if b then "T" else "F", row)),
       truthTable(e)))}
""";
}