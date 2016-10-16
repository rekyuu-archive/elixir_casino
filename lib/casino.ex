defmodule Casino do
  import Casino.Util
  alias Casino.Model.{Error, User}

  unless File.exists?("_db"), do: File.mkdir("_db")

  @initial_coins Application.get_env(:casino, :initial_coins)

  @spec create_user(String.t) :: {:ok, User.t} | {:error, Error.t}
  def create_user(username) do
    {:ok, user} = query_data("users", username)

    case user do
      nil -> store_data("users", username, %User{coins: @initial_coins, bets: %{roulette: [], blackjack: nil}})
      _user -> {:error, %Error{message: "User already exists."}}
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

  @spec delete_user(String.t) :: :ok | {:error, Error.t}
  def delete_user(username) do
    {:ok, user} = query_data("users", username)

    case user do
      nil -> {:error, %Error{message: "User does not exist."}}
      _user -> delete_data("users", username)
    end
  end

  @spec make_bet(String.t, atom, Bet.t) :: {:ok, User.t} | {:error, Error.t}
  def make_bet(username, game, bet) do
    {:ok, user} = query_data("users", username)

    case user do
      nil -> {:error, %Error{message: "User does not exist."}}
      user ->
        cond do
          bet.amount > user.coins -> {:error, %Error{message: "You don't have enough coins."}}
          true ->
            bets = user.bets |> Map.put(game, user.bets[game] ++ [bet])
            user = user
                   |> Map.put(:coins, user.coins - bet.amount)
                   |> Map.put(:bets, bets)

            store_data("users", username, user)
        end
    end
  end
end
