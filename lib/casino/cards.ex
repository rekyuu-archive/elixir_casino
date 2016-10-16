defmodule Casino.Cards do
  alias Casino.Model.{Card, Deck, Draw, Error}

  @suits [:hearts, :diamonds, :clubs, :spades]
  @values 2..14

  @spec new_deck :: {:ok, Deck.t}
  def new_deck(num \\ 1) do
    cards = for suit <- @suits, value <- @values do
      suit_name = suit |> Atom.to_string |> String.capitalize
      face_name = case value do
        11 -> "Jack"
        12 -> "Queen"
        13 -> "King"
        14 -> "Ace"
         n -> "#{n}"
      end

      %Card{name: "#{face_name} of #{suit_name}", suit: suit, value: value}
    end

    cards = (for _ <- 1..num, do: cards) |> List.flatten
    cards = cards |> Enum.shuffle |> Enum.chunk(div(length(cards), 2)) |> Enum.reverse |> List.flatten

    {:ok, %Deck{cards: Enum.shuffle(cards |> List.flatten)}}
  end

  @spec draw_card(Deck.t) :: {:ok, Draw.t} | {:error, Error.t}
  def draw_card(deck) do
    case deck.cards do
      [] -> {:error, %Error{message: "There are no more cards."}}
      cards ->
        card = List.first(cards)
        {:ok, %Draw{card: card, deck: %Deck{cards: cards -- [card]}}}
    end
  end

  @spec deal_cards(Deck.t, integer, integer) :: {:ok, map} | {:error, Error.t}
  def deal_cards(deck, players, cards) do
    cond do
      players * cards > length(deck.cards) ->
        {:error, %Error{message: "There are not enough cards in the deck."}}
      players * cards < length(deck.cards) ->
        hands = deck.cards |> Enum.take(cards * players) |> Enum.chunk(players)
        cards = deck.cards |> Enum.drop(cards * players)
        deck = deck |> Map.put(:cards, cards)

        {:ok, %{hands: hands, deck: deck}}
    end
  end
end
