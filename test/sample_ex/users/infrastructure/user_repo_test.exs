defmodule SampleEx.Users.Repositories.UserRepoTest do
  use SampleEx.DataCase

  alias SampleEx.Users.User
  alias SampleEx.Users.Salary
  alias SampleEx.Users.Repositories.UserRepo
  alias SampleEx.Users.Repositories.SalaryRepo
  alias SampleEx.Users.Repositories.Filters.UserFilters

  describe "store user" do
    test "stores user" do
      {:ok, user} = UserRepo.store(%User{}, %{name: "Jon", email: "jon@snow.com"})
      assert Repo.get(User, user.id) == user
    end

    test "does not store user without name" do
      {:error, user} = UserRepo.store(%User{}, %{name: "", email: "jon@snow.com"})
      assert user.valid? == false
    end

    test "does not store user without email" do
      {:error, user} = UserRepo.store(%User{}, %{name: "Jon", email: ""})
      assert user.valid? == false
    end

    test "does not store user with already existing email" do
      UserRepo.store(%User{}, %{name: "Jon", email: "jon@snow.com"})
      {:error, user} = UserRepo.store(%User{}, %{name: "Ned", email: "jon@snow.com"})
      assert user.valid? == false
    end
  end

  describe "list users with last active salary" do
    setup do
      {:ok, user} = UserRepo.store(%User{}, %{name: "Jon", email: "jon@snow.com"})
      {:ok, user_2} = UserRepo.store(%User{}, %{name: "Adam", email: "adam@email.com"})

      {:ok, user_salary} =
        SalaryRepo.store(%Salary{}, %{amount: 10, active: true, currency: :USD, user_id: user.id})

      {:ok, user_2_salary} =
        SalaryRepo.store(%Salary{}, %{amount: 5, active: true, currency: :USD, user_id: user_2.id})

      {:ok, user: user, user_2: user_2, user_salary: user_salary, user_2_salary: user_2_salary}
    end

    test "lists users with last active salary without filters ordered by name",
         %{user: user, user_2: user_2, user_salary: user_salary, user_2_salary: user_2_salary} do
      filters = struct(UserFilters, %{})

      users = UserRepo.list_users_with_last_active_salary(filters)
      assert List.first(users) == %{salary: user_2_salary, user: user_2}
      assert List.last(users) == %{salary: user_salary, user: user}
    end

    test "list users filtered by name", %{user: user, user_salary: user_salary} do
      filters = struct(UserFilters, %{name: "Jon"})

      users = UserRepo.list_users_with_last_active_salary(filters)
      assert length(users) == 1
      assert List.first(users) == %{salary: user_salary, user: user}
    end

    test "list users filtered by partial name", %{user: user, user_salary: user_salary} do
      {:ok, user2} = UserRepo.store(%User{}, %{name: "Jonas", email: "jonas@snow.com"})

      {:ok, salary2} =
        SalaryRepo.store(%Salary{}, %{amount: 10, active: true, currency: :USD, user_id: user2.id})

      filters = struct(UserFilters, %{name: "Jon"})

      users = UserRepo.list_users_with_last_active_salary(filters)
      assert length(users) == 2
      assert List.first(users) == %{salary: user_salary, user: user}
      assert List.last(users) == %{salary: salary2, user: user2}
    end

    test "list users filtered by email", %{user: user, user_salary: user_salary} do
      filters = struct(UserFilters, %{email: "jon@snow.com"})

      users = UserRepo.list_users_with_last_active_salary(filters)
      assert length(users) == 1
      assert List.first(users) == %{salary: user_salary, user: user}
    end

    test "list users and their lates salary if no active one is present" do
      {:ok, user} = UserRepo.store(%User{}, %{name: "Jane", email: "jane@email.com"})
      SalaryRepo.store(%Salary{}, %{currency: :USD, amount: 10, user_id: user.id, active: false})

      {:ok, new_salary} =
        SalaryRepo.store(%Salary{}, %{currency: :GBP, amount: 10, user_id: user.id, active: false})

      filters = struct(UserFilters, %{name: "Jane"})

      users = UserRepo.list_users_with_last_active_salary(filters)
      assert List.first(users) == %{salary: new_salary, user: user}
    end
  end
end
