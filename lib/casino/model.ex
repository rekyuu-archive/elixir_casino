defmodule Casino.Model do
  defmodule Bet do
    defstruct id: nil, name: nil, numbers: nil, amount: nil, payout: nil
    @type t :: %Bet{id: integer, name: String.t, numbers: [integer], amount: integer, payout: integer}
  end

  defmodule Error do
    defexception message: nil
    @type t :: %Error{message: String.t}
  end

  defmodule Result do
    defstruct result: nil, amount: nil, user: nil
    @type t :: %Result{result: String.t, amount: integer, user: User.t}
  end

  defmodule User do
    defstruct coins: nil, bets: nil
    @type t :: %User{coins: integer, bets: [Bet.t]}
  end
end
