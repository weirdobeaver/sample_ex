defmodule SampleEx.Users.Services.ListUsersWithActiveSalaryTest do
  use SampleEx.DataCase

  alias SampleEx.Users.User
  alias SampleEx.Users.Salary
  alias SampleEx.Users.Repositories.SalaryRepo
  alias SampleEx.Users.Repositories.UserRepo
  alias SampleEx.Users.Services.ListUsersWithActiveSalary

  describe "list users with last active salary" do
    setup do
      {:ok, user} = UserRepo.store(%User{}, %{name: "Jon", email: "jon@snow.com"})
      {:ok, user_2} = UserRepo.store(%User{}, %{name: "Adam", email: "adam@example.com"})

      {:ok, user_salary} =
        SalaryRepo.store(%Salary{}, %{amount: 10, active: true, currency: :USD, user_id: user.id})

      {:ok, user_2_salary} =
        SalaryRepo.store(%Salary{}, %{amount: 5, active: true, currency: :USD, user_id: user_2.id})

      {:ok, user: user, user_2: user_2, user_salary: user_salary, user_2_salary: user_2_salary}
    end

    test "list users filtered by name", %{user: user, user_salary: user_salary} do
      params = %{name: "Jon"}

      users = ListUsersWithActiveSalary.list_users_with_last_active_salary(params)
      assert length(users) == 1
      assert List.first(users) == %{salary: user_salary, user: user}
    end

    test "list all users with last active salary ordered by name", %{
      user: user,
      user_salary: user_salary,
      user_2: user_2,
      user_2_salary: user_2_salary
    } do
      users = ListUsersWithActiveSalary.list_users_with_last_active_salary(%{})
      assert length(users) == 2
      assert List.first(users) == %{salary: user_2_salary, user: user_2}
      assert List.last(users) == %{salary: user_salary, user: user}
    end
  end
end
