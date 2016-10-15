defmodule Casino do
  import Casino.Util
  alias Casino.Model.{Error, User}

  unless File.exists?("_db"), do: File.mkdir("_db")

  @initial_coins Application.get_env(:casino, :initial_coins)

  @spec create_user(String.t) :: {:ok, User.t}
  def create_user(username) do
    store_data("users", username, %User{coins: @initial_coins, bets: []})
  end

  @spec get_user(String.t) :: {:ok, User.t} | {:error, Error.t}
  def get_user(username) do
    {:ok, user} = query_data("users", username)

    case user do
      nil -> {:error, %Error{message: "User does not exist."}}
      user -> {:ok, user}
    end
  end

  @spec make_bet(String.t, {:ok, Bet.t}) :: {:ok, User.t} | {:error, Error.t}
  def make_bet(username, {:ok, bet}) do
    {:ok, user} = query_data("users", username)
    cond do
      bet.bet > user.coins -> {:error, %Error{message: "You don't have enough coins."}}
      true ->
        user = Map.put(user, :coins, user.coins - bet.bet)
        user = Map.put(user, :bets, user.bets ++ [bet])

        store_data("users", username, user)
    end
  end
end
