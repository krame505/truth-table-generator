grammar logic;

parser parse::Expr_c {
  logic;
}

function main
IOVal<Integer> ::= args::[String] io_in::IO
{
  local parseResult::ParseResult<Expr_c> = parse(head(args), "<args>");
  local output::String =
    if parseResult.parseSuccess
    then showTruthTable(parseResult.parseTree.ast)
    else parseResult.parseErrors ++ "\n";

  return ioval(print(output, io_in), if parseResult.parseSuccess then 0 else 1);
}
