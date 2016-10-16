defmodule Casino.Cards.Blackjack do
  import Casino.Util
  alias Casino.Model.{CardGame, Error}

  @bet_low  Application.get_env(:casino, :blackjack_low)
  @bet_high Application.get_env(:casino, :blackjack_high)

  @spec deal(String.t, integer) :: {:ok, CardGame.t} | {:error, Error.t}
  def deal(username, bet) do
    {:ok, user} = Casino.get_user(username)

    cond do
      bet > user.coins ->
        {:error, %Error{message: "You do not have enough coins."}}
      bet < @bet_low or bet > @bet_high ->
        {:error, %Error{message: "Be sure your bet is between #{@bet_low} and #{@bet_high} coins."}}
      true ->
        {deck, turn} =
          case user.bets.blackjack do
            nil ->
              {:ok, deck} = Casino.Cards.new_deck(6)
              {deck, 0}
            game -> {game.deck, game.turn}
          end

        cond do
          turn == 0 ->
            {:ok, deal} = deck |> Casino.Cards.deal_cards(2, 2)

            game = %CardGame{amount: bet, payout: 1, deck: deal.deck, hands: [dealer: Enum.fetch(deal.hands, 0), player: Enum.fetch(deal.hands, 1)], turn: 1}

            bets = user.bets |> Map.put(:blackjack, game)
            user = user
                   |> Map.put(:coins, user.coins - bet)
                   |> Map.put(:bets, bets)

            {:ok, user} = store_data("users", username, user)
            {:ok, game}
          true ->
            {:error, %Error{message: "Initial deal has already been made or a game is in progress already."}}
        end
    end
  end

  def stand(username) do
    nil
  end

  def hit(username) do
    nil
  end

  def quit(username) do
    nil
  end
end
