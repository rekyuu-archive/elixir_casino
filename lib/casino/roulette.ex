defmodule Casino.Roulette do
  import Casino.Util
  alias Casino.Model.{Error, Result}

  @spec spin(String.t) :: {:ok, Result.t} | {:error, Error.t}
  def spin(username) do
    {:ok, user} = query_data("users", username)

    number = Enum.random(0..36)
    color = cond do
      Enum.member?(Casino.Roulette.Methods.reds, number) -> "Red"
      Enum.member?(Casino.Roulette.Methods.blacks, number) -> "Black"
    end

    coins = user.coins
    case user.bets do
      [] -> {:error, %Error{message: "You have not made any bets."}}
      bets ->
        payouts = for bet <- bets do
          cond do
            number in bet.numbers -> bet.bet + (bet.bet * bet.payout)
            true -> 0
          end
        end

        user = Map.put(user, :coins, coins + sum_list(payouts))
        user = Map.put(user, :bets, [])
        {:ok, user} = store_data("users", username, user)

        {:ok, %Result{result: "#{color} #{number}", amount: sum_list(payouts), user: user}}
    end
  end
end
