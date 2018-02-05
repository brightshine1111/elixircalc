defmodule Lexer do
    # Much inspiration for this module is from:
    # https://github.com/fabrik42/writing_an_interpreter_in_elixir/blob/master/lib/monkey/lexer.ex
    
    # The algorithm for getting the tokens into reverse-polish notation is the Shunting-yard algorithm:
    # https://en.wikipedia.org/wiki/Shunting-yard_algorithm
    
    def lex(expr) do
        chars = String.split(expr, "", trim: true)
        tokenize(chars, [], [])
    end

    # Gonna tokenize and RPN them at the same time
    defp tokenize(chars = [ch | rest], out, ops) do
        cond do
            String.match?(ch, ~r/[\n\r \t]/) -> tokenize(rest, out, ops)
            is_num(ch) -> process_number(chars, out, ops)
            String.match?(ch, ~r/[\+\-\*\/]/) -> process_op(ch, out, ops, rest)
            ch === "(" -> process_par_open(out, ops, rest)
            ch === ")" -> process_par_close(out, ops, rest)
            true -> raise("Invalid token: " <> ch)
        end
    end

    defp tokenize(_chars = [], out, ops) do
        #IO.puts("> End of input")

        if List.first(ops) === :par_open do
            raise("Mismatched bracket in input")
        end

        Enum.reverse(ops) ++ out
        |> Enum.reverse()
        # Output is in reverse-polish notation
        #IO.puts("Out: #{inspect(out)}")
    end

    defp process_number(chars, out, ops) do
        {num, rest} = Enum.split_while(chars, &is_num/1)
        num = Enum.join(num)
        token = Token.new(String.to_integer(num))
        #IO.puts("Made new token #{inspect(token)}")
        tokenize(rest, [token | out], ops)
    end

    defp process_op(op, out, ops, rest) do
        token = Token.new(op)
        #IO.puts("Made new token #{inspect(token)}")

        {moved_ops, rem_ops} = Enum.split_while(ops, fn(st_op) -> 
            (st_op !== :par_open) && (st_op.prec >= token.prec)
        end)
        #IO.puts("Found op #{op}, moved ops #{inspect(moved_ops)}, rem ops: #{inspect(rem_ops)}")
        tokenize(rest, Enum.reverse(moved_ops) ++ out, [token | rem_ops])
    end

    defp process_par_open(out, ops, rest) do
        #IO.puts("Found open par")
        tokenize(rest, out, [:par_open | ops])
    end

    defp process_par_close(out, ops, rest) do
        # move ops to out stack until hit open par
        {moved_ops, rem_ops} = Enum.split_while(ops, &(&1 !== :par_open))
        #IO.puts("Found close par, moved ops #{inspect(moved_ops)}")
        # also pop :par_open from ops stack
        tokenize(rest, moved_ops ++ out, List.delete_at(rem_ops, 0))
    end

    defp is_num(ch) when is_binary(ch) do
        String.match?(ch, ~r/[0-9]/)
    end
end