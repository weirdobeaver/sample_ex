defmodule SampleEx.Users.Repositories.SalaryRepoTest do
  use SampleEx.DataCase

  alias SampleEx.Users.{Salary, User}
  alias SampleEx.Users.Repositories.{SalaryRepo, UserRepo}

  describe "store salary" do
    setup do
      {:ok, user} = UserRepo.store(%User{}, %{name: "Jon", email: "jon@snow.com"})
      {:ok, user: user}
    end

    test "stores salary", %{user: user} do
      attrs = %{currency: :USD, amount: 10, user_id: user.id, active: true}
      {:ok, salary} = SalaryRepo.store(%Salary{}, attrs)
      assert Repo.get(Salary, salary.id) == salary
    end

    test "does not store salary without currency", %{user: user} do
      attrs = %{currency: nil, amount: 10, user_id: user.id, active: true}
      {:error, salary} = SalaryRepo.store(%Salary{}, attrs)
      assert salary.valid? == false
    end

    test "does not store salary without amount", %{user: user} do
      attrs = %{currency: :USD, amount: nil, user_id: user.id, active: true}
      {:error, salary} = SalaryRepo.store(%Salary{}, attrs)
      assert salary.valid? == false
    end

    test "does not store salary without user_id" do
      attrs = %{currency: :USD, amount: 10, user_id: nil, active: true}
      {:error, salary} = SalaryRepo.store(%Salary{}, attrs)
      assert salary.valid? == false
    end

    test "does not store salary with invalid currency", %{user: user} do
      attrs = %{currency: :CHF, amount: 10, user_id: user.id, active: true}
      {:error, salary} = SalaryRepo.store(%Salary{}, attrs)
      assert salary.valid? == false
    end

    test "does not store salary with amount equals 0 or less", %{user: user} do
      attrs = %{currency: :USD, amount: 0, user_id: user.id, active: true}
      {:error, salary} = SalaryRepo.store(%Salary{}, attrs)
      assert salary.valid? == false
    end

    test "does not store active salary if one already exists", %{user: user} do
      attrs = %{currency: :USD, amount: 10, user_id: user.id, active: true}
      SalaryRepo.store(%Salary{}, attrs)
      {:error, salary} = SalaryRepo.store(%Salary{}, attrs)
      assert salary.valid? == false
      assert salary.errors == [active: {"active salary already present", []}]
    end

    test "stores active salary if none active already exists", %{user: user} do
      attrs = %{currency: :USD, amount: 10, user_id: user.id, active: false}
      SalaryRepo.store(%Salary{}, attrs)
      active_attrs = %{currency: :USD, amount: 10, user_id: user.id, active: true}
      {:ok, salary} = SalaryRepo.store(%Salary{}, active_attrs)
      assert Repo.get(Salary, salary.id) == salary
    end
  end

  describe "Load all active salaries by user id" do
    setup do
      {:ok, user} = UserRepo.store(%User{}, %{name: "Jon", email: "jon@snow.com"})
      {:ok, user2} = UserRepo.store(%User{}, %{name: "Ned", email: "ned@stark.com"})
      attrs = %{currency: :USD, amount: 10, user_id: user.id, active: true}
      {:ok, salary} = SalaryRepo.store(%Salary{}, attrs)
      SalaryRepo.store(%Salary{}, attrs |> Map.put(:user_id, user2.id))
      SalaryRepo.store(%Salary{}, attrs |> Map.put(:active, false))
      {:ok, user: user, salary: salary}
    end

    test "returns empty list if no user id given" do
      salaries = SalaryRepo.load_all_active_by_user_id(nil)
      assert salaries == []
    end

    test "returns only active salaries for given user_id", %{salary: salary} do
      salaries = SalaryRepo.load_all_active_by_user_id(salary.user_id)
      assert salaries == [salary]
    end
  end
end
