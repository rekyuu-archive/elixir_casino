defmodule Casino do
  import Casino.Util
  alias Casino.Model.{Error, User}

  unless File.exists?("_db"), do: File.mkdir("_db")

  @initial_coins Application.get_env(:casino, :initial_coins)

  @spec create_user(String.t) :: {:ok, User.t}
  def create_user(username) do
    {:ok, user} = query_data("users", username)

    case user do
      nil -> store_data("users", username, %User{coins: @initial_coins, bets: []})
      user -> {:error, %Error{message: "User already exists."}}
    end
  end

  @spec get_user(String.t) :: {:ok, User.t} | {:error, Error.t}
  def get_user(username) do
    {:ok, user} = query_data("users", username)

    case user do
      nil -> {:error, %Error{message: "User does not exist."}}
      user -> {:ok, user}
    end
  end

  @spec make_bet(String.t, Bet.t) :: {:ok, User.t} | {:error, Error.t}
  def make_bet(username, bet) do
    {:ok, user} = query_data("users", username)
    cond do
      bet.amount > user.coins -> {:error, %Error{message: "You don't have enough coins."}}
      true ->
        user = user
               |> Map.put(:coins, user.coins - bet.bet)
               |> Map.put(:bets, user.bets ++ [bet])

        store_data("users", username, user)
    end
  end
end
