defmodule SampleEx.Common.Query do
  @moduledoc """
    Generic query module for extending or query functions.
    Here you will find:
    - type: filter_modules, this type will define all the possibles filter modules arround the application.
    - function: compose_query, this is a generic function that given a base Ecto.Query, filters,
    and a function will return an extended Ecto.Query
  """

  alias SampleEx.Users.Repositories.Filters.UserFilters

  @type filter_modules() :: UserFilters.t() | struct() | map()

  @doc """

  compose_query function requires 3 elements;
  1. A base Ecto.Query to be extended by filters.
  2. A filter Struct, where is defined all the filter to apply.
  3. A fuction which define how to apply the filters to the base query.
  As recomendation every repository should define its own apply function.

  As result it will returns a more complex Ecto.Query

  ## Examples

      iex> base_query = from(u in User)
      #Ecto.Query<from u0 in SampleEx.Users.User>

      iex> filters = %UserFilters{name: "John"}
      %SampleEx.Users.Repositories.Filters.UserFilters{
        name: "John"
      }

      iex> apply_function = &UserRepo.apply_filters/2
      &SampleEx.Users.Repositories.UserRepo.apply_filters/2

      iex> extended_query = Query.compose_query(base_query, filters, apply_function)
      #Ecto.Query<from u0 in SampleEx.Users.User, where: u0.name == ^"John">
  """
  @spec compose_query(Ecto.Query.t(), filter_modules(), fun()) :: Ecto.Query.t()
  def compose_query(query, filters, apply_function) when is_struct(filters) do
    destructured_filters = filters |> Map.from_struct()
    reduce_query_filters(query, destructured_filters, apply_function)
  end

  def compose_query(query, filters, apply_function) when is_map(filters) do
    reduce_query_filters(query, filters, apply_function)
  end

  defp reduce_query_filters(query, filters, apply_function) do
    Enum.reduce(filters, query, fn filter, query ->
      apply_function.(filter, query)
    end)
  end
end
