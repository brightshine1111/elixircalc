defmodule Calc do
  def main do
    IO.gets("> ")
    |> String.trim()
    |> eval()
    |> IO.puts()

    main()
  end

  def eval(expr) do
    Lexer.lex(expr)
    |> Parser.parse()
  end
end
