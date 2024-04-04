defmodule SampleEx.Users.Salary do
  @moduledoc """
  Represents single Salary
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SampleEx.Users.User
  alias SampleEx.Users.Repositories.SalaryRepo

  @type currency() :: :USD | :EUR | :GBP | :PLN
  @type t() :: %__MODULE__{
          id: integer(),
          amount: number(),
          currency: currency(),
          active: boolean(),
          user_id: integer()
        }

  @valid_currencies [:EUR, :USD, :GBP, :PLN]

  schema "salaries" do
    field :amount, :decimal
    field :currency, Ecto.Enum, values: @valid_currencies
    field :active, :boolean
    belongs_to :user, User

    timestamps(type: :utc_datetime_usec)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(salary, attrs) do
    salary
    |> cast(attrs, [
      :amount,
      :currency,
      :active,
      :user_id
    ])
    |> validate_required([
      :amount,
      :currency,
      :user_id
    ])
    |> validate_inclusion(:currency, @valid_currencies)
    |> validate_number(:amount, greater_than: 0)
    |> validate_only_one_active_per_user()
  end

  @spec validate_only_one_active_per_user(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def validate_only_one_active_per_user(changeset) do
    case get_field(changeset, :active) do
      true -> check_other_user_active_salaries(changeset)
      _ -> changeset
    end
  end

  defp check_other_user_active_salaries(changeset) do
    case SalaryRepo.load_all_active_by_user_id(get_field(changeset, :user_id)) do
      [] -> changeset
      _ -> add_error(changeset, :active, "active salary already present")
    end
  end
end
