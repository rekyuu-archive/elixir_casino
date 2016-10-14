defmodule Casino do
  import Casino.Util

  unless File.exists?("_db"), do: File.mkdir("_db")

  @initial_coins Application.get_env(:casino, :initial_coins)

  def create_user(user) do
    store_data("users", user, %{coins: @initial_coins, bets: []})
  end

  def get_coins(user) do
    data = query_data("users", user)
    data.coins
  end
end
