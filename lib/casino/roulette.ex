defmodule Casino.Roulette do
  import Casino.Util
  alias Casino.Model.{Error, Result}

  @spec spin(String.t) :: {:ok, Result.t} | {:error, Error.t}
  def spin(username) do
    {:ok, user} = Casino.get_user(username)

    number = Enum.random(0..36)
    color = cond do
      number in Casino.Roulette.Bet.reds -> "Red "
      number in Casino.Roulette.Bet.blacks -> "Black "
      true -> ""
    end

    coins = user.coins
    case user.bets.roulette do
      [] -> {:error, %Error{message: "You have not made any bets."}}
      bets ->
        payouts = for bet <- bets do
          cond do
            number in bet.numbers -> bet.amount + (bet.amount * bet.payout)
            true -> 0
          end
        end

        clear_bets = user.bets |> Map.put(:roulette, [])
        user = user
               |> Map.put(:coins, coins + Enum.sum(payouts))
               |> Map.put(:bets, clear_bets)
        {:ok, user} = store_data("users", username, user)

        {:ok, %Result{result: "#{color}#{number}", amount: Enum.sum(payouts), user: user}}
    end
  end
end
