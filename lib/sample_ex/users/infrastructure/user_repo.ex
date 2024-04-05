defmodule SampleEx.Users.Repositories.UserRepo do
  @moduledoc """
  User database operations
  """

  import Ecto.Query

  @type user_with_salary() :: %{
          user: SampleEx.Users.User.t(),
          salary: SampleEx.Users.Salary.t()
        }

  alias SampleEx.Repo
  alias SampleEx.Users.Repositories.SalaryRepo
  alias SampleEx.Users.Repositories.Filters.UserFilters
  alias SampleEx.Common.Query
  alias SampleEx.Users.User

  defdelegate fetch_latest_salaries_subquery, to: SalaryRepo

  @spec store(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def store(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec list_users_with_active_salary() :: [
          %{id: pos_integer(), name: String.t(), email: String.t()}
        ]
  def list_users_with_active_salary() do
    from(u in User,
      left_join: s in assoc(u, :salaries),
      where: s.active == true,
      select: [:id, :name, :email]
    )
    |> Repo.all()
  end

  @spec list_users_with_last_active_salary(UserFilters.t()) :: [user_with_salary()]
  def list_users_with_last_active_salary(filters) do
    base_query =
      from(u in User,
        left_join: s in subquery(fetch_latest_salaries_subquery()),
        on: s.user_id == u.id,
        select: %{user: u, salary: s},
        order_by: u.name
      )

    base_query
    |> Query.compose_query(filters, &apply_filter/2)
    |> Repo.all()
  end

  defp apply_filter({_, :undefined}, query), do: query

  defp apply_filter({:name, name}, query) do
    query |> where([u], ilike(u.name, ^"%#{name}%"))
  end

  defp apply_filter({:email, nil}, query), do: query

  defp apply_filter({:email, email}, query) do
    query |> where([u], u.email == ^email)
  end

  defp apply_filter({:order, order_params}, query) do
    query |> order_by(^order_params)
  end

  defp apply_filter(_, query), do: query
end
