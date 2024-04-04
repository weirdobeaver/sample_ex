defmodule SampleEx.Users.Repositories.Filters.UserFilters do
  @moduledoc """
    Struct to define all the possible filters for querying users.
    When a property contains an :undefined value, we can consider skipping any filter application.
    In this sense, we can have properties with values nil or blank and still apply a filter definition.
  """

  @type undefined() :: :undefined
  @type t :: %__MODULE__{
          name: String.t() | undefined()
        }

  @undefined :undefined
  defstruct name: @undefined,
            email: @undefined
end
