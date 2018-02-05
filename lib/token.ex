defmodule Token do
    # Much inspiration for this module is from:
    # https://github.com/fabrik42/writing_an_interpreter_in_elixir/blob/master/lib/monkey/token.ex
    
    @enforce_keys [:type]
    defstruct [:type, :val, :prec]

    # Specify precedence of operators
    @op_prec %{
        "+" => 1,
        "-" => 1,
        "*" => 2,
        "/" => 2
    }

    def new(val) when is_integer(val) do
        %__MODULE__{type: :num, val: val}
    end

    def new(val) when is_binary(val) do
        # Also doubles as checking validity of operator
        if Map.has_key?(@op_prec, val) do
            %__MODULE__{type: :op, val: val, prec: @op_prec[val]}
        else
            raise("Invalid operator: " <> val)
        end
    end
end