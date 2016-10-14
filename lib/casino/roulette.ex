defmodule Casino.Roulette do
  require Logger

  import Casino.Util
  alias Casino.Roulette.Model.Bet

  @spec make_bet(String.t, {:ok, Bet.t}) :: String.t
  def make_bet(username, {:ok, bet}) do
    user = query_data("users", username)
    cond do
      bet.bet > user.coins -> Logger.info "You don't have enough coins."
      true ->
        user = Map.put(user, :coins, user.coins - bet.bet)
        user = Map.put(user, :bets, user.bets ++ [bet])
        store_data("users", username, user)
        Logger.info "Made bet."
    end
  end

  def spin(username) do
    user = query_data("users", username)

    Logger.info "Spinning the roulette!"
    :timer.sleep(1000)
    Logger.info "3..."
    :timer.sleep(1000)
    Logger.info "2..."
    :timer.sleep(1000)
    Logger.info "1..."
    :timer.sleep(1000)

    result = Enum.random(0..36)
    color = cond do
      Enum.member?(Casino.Roulette.Model.reds, result) -> "Red"
      Enum.member?(Casino.Roulette.Model.blacks, result) -> "Black"
    end

    Logger.info "Landed on #{result} (#{color})!"

    coins = user.coins

    case user.bets do
      [] -> Logger.info "You haven't made any bets."
      bets ->
        payouts = for bet <- bets do
          cond do
            result in bet.numbers -> bet.bet + (bet.bet * bet.payout)
            true -> 0
          end
        end

        cond do
          sum_list(payouts) == 0 -> Logger.info "Sorry, you didn't win anything."
          true ->
            coins = coins + sum_list(payouts)
            store_data("users", username, Map.put(user, :coins, coins))
            Logger.info "Congrats, you won #{sum_list(payouts)} coins!"
        end

        user = query_data("users", username)
        Logger.info "You now have #{user.coins} coins."
        store_data("users", username, Map.put(user, :bets, []))
    end
  end
end
