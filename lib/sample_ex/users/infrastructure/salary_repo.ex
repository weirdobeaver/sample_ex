defmodule SampleEx.Users.Repositories.SalaryRepo do
  @moduledoc """
  Salary database operations
  """

  alias SampleEx.Repo
  alias SampleEx.Users.Salary

  import Ecto.Query

  @spec store(Salary.t(), map()) :: {:ok, Salary.t()} | {:error, Ecto.Changeset.t()}
  def store(salary, attrs) do
    salary
    |> Salary.changeset(attrs)
    |> Repo.insert()
  end

  def load_all_active_by_user_id(nil), do: []
  @spec load_all_active_by_user_id(pos_integer()) :: [Salary.t()]
  def load_all_active_by_user_id(user_id) do
    Salary
    |> where(user_id: ^user_id)
    |> where(active: true)
    |> Repo.all()
  end

  @doc """
    Build a subquery to fetch the latest salaries for each user.
    recommendations:
    - Use this subquery to fetch the latest salaries for each user.
  """

  @spec fetch_latest_salaries_subquery() :: Ecto.Query.t()
  def fetch_latest_salaries_subquery do
    from(s in Salary,
      order_by: [desc: s.active, desc: s.inserted_at],
      distinct: s.user_id
    )
  end
end
