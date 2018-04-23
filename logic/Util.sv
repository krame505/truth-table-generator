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
[[[Boolean]]] ::= es::[Expr]
{
  return
    map(
      \ a::[Pair<String Boolean>] -> map(values(_, a), es),
      possibleAssignments(foldr(unionBy(stringEq, _, _), [], map((.vars), es))));
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
          if isTopLevel then "$$\\mathbf{" ++ item ++ "}$$" else "$$" ++ item ++ "$$",
        items,
        map(\ component::Decorated Expr -> component.isTopLevel, e.components)));
}

function showTruthTable
String ::= es::[Expr]
{
  return s"""
${implode(
    " | | ",
    map(
      \ e::Expr ->
        implode(" | ", map(\  s::String -> "$$" ++ s ++ "$$", map(show(100, _), e.pps))), es))}
${implode(" | ", repeat(":-:", length(es) + length(concat(map((.values), es)))))}
${implode(
    "\n",
    map(
      \ row::[[Boolean]] ->
        implode(
          " | | ",
          zipWith(
            \ e::Expr items::[Boolean] ->
              formatRow(e, map(\ b::Boolean -> if b then "T" else "F", items)),
            es, row)),
      truthTable(es)))}
""";
}

function rangeFrom
[Integer] ::= from::Integer
{
  return from :: rangeFrom(from + 1);
}
