defmodule SampleEx.Users.Services.ListUsersWithActiveSalary do
  alias SampleEx.Users.Repositories.UserRepo
  alias SampleEx.Users.Repositories.Filters.UserFilters

  @spec list_users_with_last_active_salary(map()) :: [
          %{salary: SampleEx.Users.Salary.t(), user: SampleEx.Users.User.t()}
        ]
  def list_users_with_last_active_salary(params) do
    filters = struct(UserFilters, params)

    UserRepo.list_users_with_last_active_salary(filters)
  end
end
