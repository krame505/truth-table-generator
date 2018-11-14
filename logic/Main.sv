grammar logic;

parser parse::Expr_c {
  logic;
}

function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  local parseResults::[ParseResult<Expr_c>] =
    zipWith(parse, args, map(\ i::Integer -> s"<arg ${toString(i)}>", rangeFrom(1)));
  local parseErrors::[String] =
    concat(
      map(
        \ p::ParseResult<Expr_c> -> if !p.parseSuccess then [p.parseErrors] else [],
        parseResults));
  local output::String =
    if null(parseErrors)
    then showTruthTable(map(\ p::ParseResult<Expr_c> -> p.parseTree.ast, parseResults))
    else implode("\n", parseErrors) ++ "\n";

  return ioval(print(output, io_in), if null(parseErrors) then 0 else 1);
}
