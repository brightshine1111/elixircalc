defmodule Parser do
    def parse(tokens) do
        eval(tokens, [])
    end
    
    def eval([token | rest], stack) do
        stack =
            case token.type do
                :op -> parse_op(token, stack)
                :num -> [token.val | stack]
                _ -> raise("Invalid token: #{inspect(token)}")
            end

        eval(rest, stack)
    end

    def eval(_tokens = [], stack) do
        Enum.at(stack, 0)
    end

    def parse_op(token, stack) do
        {operands, stack} = Enum.split(stack, 2)
        [perform_op(operands, token.val) | stack]
    end

    def perform_op(operands, op) when op === "+" do
        Enum.at(operands, 1) + Enum.at(operands, 0)
    end

    def perform_op(operands, op) when op === "-" do
        Enum.at(operands, 1) - Enum.at(operands, 0)
    end

    def perform_op(operands, op) when op === "*" do
        Enum.at(operands, 1) * Enum.at(operands, 0)
    end

    def perform_op(operands, op) when op === "/" do
        div(Enum.at(operands, 1), Enum.at(operands, 0))
    end
end