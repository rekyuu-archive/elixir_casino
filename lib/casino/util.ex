defmodule Casino.Util do
  def sum_list([]), do: 0
  def sum_list([h|t]), do: h + sum_list(t)

  @spec store_data(String.t, String.t, any) :: {:ok, any}
  def store_data(table, key, value) do
    file = '_db/#{table}.dets'
    {:ok, _} = :dets.open_file(table, [file: file, type: :set])

    :dets.insert(table, {key, value})
    :dets.close(table)
    {:ok, value}
  end

  @spec query_data(String.t, String.t) :: {:ok, any}
  def query_data(table, key) do
    file = '_db/#{table}.dets'
    {:ok, _} = :dets.open_file(table, [file: file, type: :set])
    result = :dets.lookup(table, key)

    response =
      case result do
        [{_, value}] -> value
        [] -> nil
      end

    :dets.close(table)
    {:ok, response}
  end

  @spec delete_data(String.t, String.t) :: :ok | :error
  def delete_data(table, key) do
    file = '_db/#{table}.dets'
    {:ok, _} = :dets.open_file(table, [file: file, type: :set])
    response = :dets.delete(table, key)

    :dets.close(table)
    response
  end
end
