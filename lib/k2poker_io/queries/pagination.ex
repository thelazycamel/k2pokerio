defmodule K2pokerIo.Queries.Pagination do

  alias K2pokerIo.Repo

  # Kerosene doesnt seem to allow to cancel the pagination,
  # so this fixes issue, all you have to do is pass "per_page" = 0

  def paginate(query, params) do
    if params["per_page"] == 0 do
      result = Repo.all(query)
      { result, %{:per_page => 0, :total_count => Enum.count(result), :page => 1} }
    else
      Repo.paginate(query, params)
    end

  end

end
