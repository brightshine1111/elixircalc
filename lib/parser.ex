defmodule Parser do
    def parse(tokens) do
        eval(tokens, [])
    end
    
    # The algorithm for evaluating this came from RPN's wikipedia article:
    # https://en.wikipedia.org/wiki/Reverse_Polish_notation#Postfix_evaluation_algorithm
    defp eval([token | rest], stack) do
        stack =
            case token.type do
                :op -> parse_op(token, stack)
                :num -> [token.val | stack]
                _ -> raise("Invalid token: #{inspect(token)}")
            end

        eval(rest, stack)
    end

    defp eval(_tokens = [], stack) do
        Enum.at(stack, 0)
    end

    defp parse_op(token, stack) do
        {operands, stack} = Enum.split(stack, 2)
        [perform_op(operands, token.val) | stack]
    end

    defp perform_op(operands, op) when op === "+" do
        Enum.at(operands, 1) + Enum.at(operands, 0)
    end

    defp perform_op(operands, op) when op === "-" do
        Enum.at(operands, 1) - Enum.at(operands, 0)
    end

    defp perform_op(operands, op) when op === "*" do
        Enum.at(operands, 1) * Enum.at(operands, 0)
    end

    defp perform_op(operands, op) when op === "/" do
        div(Enum.at(operands, 1), Enum.at(operands, 0))
    end
end