defmodule TokenTest do
  use ExUnit.Case
  doctest Token

  test "Token.new number" do
    token = %Token{prec: nil, type: :num, val: 34}
    assert Token.new(34) == token
  end

  test "Token.new minus" do
    token = %Token{prec: 1, type: :op, val: "-"}
    assert Token.new("-") == token
  end

  test "Token.new plus" do
    token = %Token{prec: 1, type: :op, val: "+"}
    assert Token.new("+") == token
  end

  test "Token.new mult" do
    token = %Token{prec: 2, type: :op, val: "*"}
    assert Token.new("*") == token
  end

  test "Token.new div" do
    token = %Token{prec: 2, type: :op, val: "/"}
    assert Token.new("/") == token
  end
end

defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "Lexer.lex RPN notation" do
    tokens = [Token.new(5), Token.new(4), Token.new(3), Token.new("-"), Token.new("*")]
    assert Lexer.lex("5*(4-3)") == tokens
  end

  test "Lexer.lex invalid token" do
    assert_raise RuntimeError, fn -> Lexer.lex("f") end
  end

  test "Lexer.lex mismatched bracket" do
    assert_raise RuntimeError, fn -> Lexer.lex("5 + (3") end
  end
end

defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "Parser.parse produces correct value" do
    tokens = [Token.new(2), Token.new(3), Token.new(4), Token.new("+"), Token.new("*")]
    assert Parser.parse(tokens) == 14
  end

  test "Parser.parse invalid token" do
    tokens = [%Token{prec: nil, type: :fish, val: "fish"}]
    assert_raise RuntimeError, fn -> Parser.parse(tokens) end
  end
end

defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Calc.eval: Order of operations" do
    assert Calc.eval("55/5+10*2") == 31
  end

  test "Calc.eval: Whitespace" do
    assert Calc.eval(" 55/ 5 +10 * 2   ") == 31
  end

  test "Calc.eval: Parenthesis" do
    assert Calc.eval("30 / (5 + 10) * (2 * (4 + 1))") == 20
  end

  test "Calc.eval: Divide by zero" do
    assert_raise ArithmeticError, fn -> Calc.eval("5 / 0") end
  end

  test "Calc.eval: Invalid syntax" do
    assert_raise ArithmeticError, fn -> Calc.eval("+++3") end
  end
end