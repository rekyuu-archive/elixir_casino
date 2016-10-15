defmodule Casino.Roulette.Methods do
  alias Casino.Model.{Bet, Error}

  @column_1 for n <- 1..12, do: (n * 3) - 2
  @column_2 for n <- 1..12, do: (n * 3) - 1
  @column_3 for n <- 1..12, do: (n * 3)

  def reds, do: [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36]
  def blacks, do: [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35]

  @spec zero(integer) :: {:ok, Bet.t}
  def zero(bet) do
    {:ok, %Bet{id: 0, name: "Zero", numbers: [0], amount: bet, payout: 35}}
  end

  @spec straight_up(integer, integer) :: {:ok, Bet.t}
  def straight_up(number, bet) do
    {:ok, %Bet{id: 1, name: "Straight Up", numbers: [number], amount: bet, payout: 35}}
  end

  @spec horizontal_split(integer, integer) :: {:ok, Bet.t} | {:error, Error.t}
  def horizontal_split(left_number, bet) do
    cond do
      left_number in @column_3 -> {:error, %Error{message: "Please use the left number for your split."}}
      true ->
        {:ok, %Bet{id: 2, name: "Split", numbers: [left_number, left_number + 1], amount: bet, payout: 17}}
    end
  end

  @spec vertical_split(integer, integer) :: {:ok, Bet.t} | {:error, Error.t}
  def vertical_split(top_number, bet) do
    cond do
      top_number in [34, 35, 36] -> {:error, %Error{message: "Please use the top number for your split."}}
      true ->
        {:ok, %Bet{id: 3, name: "Split", numbers: [top_number, top_number + 3], amount: bet, payout: 17}}
    end
  end

  @spec street(integer, integer) :: {:ok, Bet.t} | {:error, Error.t}
  def street(left_number, bet) do
    cond do
      left_number in @column_1 -> {:error, %Error{message: "Please use the leftmost number for your street."}}
      true ->
        {:ok, %Bet{id: 4, name: "Street", numbers: [left_number, left_number + 1, left_number + 2], amount: bet, payout: 11}}
    end
  end

  @spec corner(integer, integer) :: {:ok, Bet.t} | {:error, Error.t}
  def corner(top_left_number, bet) do
    cond do
      top_left_number in @column_3 -> {:error, %Error{message: "Please use the top left number for your corner."}}
      true ->
        {:ok, %Bet{id: 5, name: "Corner", numbers: [top_left_number, top_left_number + 1, top_left_number + 3, top_left_number + 4], amount: bet, payout: 8}}
    end
  end

  @spec top_line(integer) :: {:ok, Bet.t}
  def top_line(bet) do
    {:ok, %Bet{id: 6, name: "Top Line", numbers: [0, 1, 2, 3], amount: bet, payout: 6}}
  end

  @spec six_line(integer, integer) :: {:ok, Bet.t} | {:error, Error.t}
  def six_line(top_left_number, bet) do
    cond do
      top_left_number in @column_1 ->
        {:ok, %Bet{id: 7, name: "Six Line", numbers: (for n <- top_left_number..(top_left_number + 5), do: n), amount: bet, payout: 5}}
      true -> {:error, %Error{message: "Please use the top left number for your six line."}}
    end
  end

  @spec column(integer, integer) :: {:ok, Bet.t} | {:error, Error.t}
  def column(col, bet) do
    case col do
      1 -> {:ok, %Bet{id: 8, name: "First Column", numbers: @column_1, amount: bet, payout: 2}}
      2 -> {:ok, %Bet{id: 9, name: "Second Column", numbers: @column_2, amount: bet, payout: 2}}
      3 -> {:ok, %Bet{id: 10, name: "Third Column", numbers: @column_3, amount: bet, payout: 2}}
      _ -> {:error, %Error{message: "Invalid column. Be sure to select column 1, 2 or 3."}}
    end
  end

  @spec dozen(integer, integer) :: {:ok, Bet.t} | {:error, Error.t}
  def dozen(section, bet) do
    case section do
      1 -> {:ok, %Bet{id: 11, name: "First Dozen", numbers: (for n <- 1..12, do: n), amount: bet, payout: 2}}
      2 -> {:ok, %Bet{id: 12, name: "Second Dozen", numbers: (for n <- 13..24, do: n), amount: bet, payout: 2}}
      3 -> {:ok, %Bet{id: 13, name: "Third Dozen", numbers: (for n <- 25..36, do: n), amount: bet, payout: 2}}
      _ -> {:error, %Error{message: "Invalid section. Be sure to select dozen 1, 2, or 3."}}
    end
  end

  @spec odd_numbers(integer) :: {:ok, Bet.t}
  def odd_numbers(bet) do
    {:ok, %Bet{id: 14, name: "Odd Numbers", numbers: (for n <- 1..18, do: (n * 2) - 1), amount: bet, payout: 1}}
  end

  @spec even_numbers(integer) :: {:ok, Bet.t}
  def even_numbers(bet) do
    {:ok, %Bet{id: 15, name: "Even Numbers", numbers: (for n <- 1..18, do: (n * 2)), amount: bet, payout: 1}}
  end

  @spec red_numbers(integer) :: {:ok, Bet.t}
  def red_numbers(bet) do
    {:ok, %Bet{id: 16, name: "Red Numbers", numbers: reds, amount: bet, payout: 1}}
  end

  @spec black_numbers(integer) :: {:ok, Bet.t}
  def black_numbers(bet) do
    {:ok, %Bet{id: 17, name: "Black Numbers", numbers: blacks, amount: bet, payout: 1}}
  end

  @spec low_numbers(integer) :: {:ok, Bet.t}
  def low_numbers(bet) do
    {:ok, %Bet{id: 18, name: "Low Numbers", numbers: (for n <- 1..18, do: n), amount: bet, payout: 1}}
  end

  @spec high_numbers(integer) :: {:ok, Bet.t}
  def high_numbers(bet) do
    {:ok, %Bet{id: 19, name: "Low Numbers", numbers: (for n <- 19..36, do: n), amount: bet, payout: 1}}
  end
end
