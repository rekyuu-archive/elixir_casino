defmodule Casino.Model do
  defmodule Bet do
    defstruct id: nil, name: nil, numbers: nil, amount: nil, payout: nil
    @type t :: %Bet{id: integer, name: String.t, numbers: [integer], amount: integer, payout: integer}
  end

  defmodule Card do
    defstruct name: nil, suit: nil, value: nil
    @type t :: %Card{name: String.t, suit: atom, value: integer}
  end

  defmodule CardGame do
    defstruct amount: nil, payout: nil, deck: nil, hands: nil, turn: nil
    @type t :: %CardGame{amount: integer, payout: integer, deck: Deck.t, hands: [{atom, Card.t}], turn: integer}
  end

  defmodule Deck do
    defstruct cards: nil
    @type t :: %Deck{cards: [Card.t]}
  end

  defmodule Draw do
    defstruct card: nil, deck: nil
    @type t :: %Draw{card: Card.t, deck: Deck.t}
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
    @type t :: %User{coins: integer, bets: %{roulette: [Bet.t], blackjack: CardGame.t}}
  end
end
