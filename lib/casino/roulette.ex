defmodule Casino.Roulette do
  import Casino.Util
  alias Casino.Model.{Error, Result}

  @spec spin(String.t) :: {:ok, Result.t} | {:error, Error.t}
  def spin(username) do
    {:ok, user} = query_data("users", username)

    number = Enum.random(0..36)
    color = cond do
      number in Casino.Roulette.Methods.reds -> "Red "
      number in Casino.Roulette.Methods.blacks -> "Black "
      true -> ""
    end

    coins = user.coins
    case user.bets do
      [] -> {:error, %Error{message: "You have not made any bets."}}
      bets ->
        payouts = for bet <- bets do
          cond do
            number in bet.numbers -> bet.amount + (bet.amount * bet.payout)
            true -> 0
          end
        end

        user = user
               |> Map.put(:coins, coins + sum_list(payouts))
               |> Map.put(:bets, [])
        {:ok, user} = store_data("users", username, user)

        {:ok, %Result{result: "#{color}#{number}", amount: sum_list(payouts), user: user}}
    end
  end
end
