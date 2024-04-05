defmodule SampleEx.Users.Services.SendEmailToActiveSalaryUsersTest do
  use SampleEx.DataCase

  alias SampleEx.Users.User
  alias SampleEx.Users.Salary
  alias SampleEx.Users.Repositories.SalaryRepo
  alias SampleEx.Users.Repositories.UserRepo
  alias SampleEx.Users.Services.SendEmailToActiveSalaryUsers
  alias SampleEx.Users.Workers.SendMultipleEmailsJob

  setup do
    {:ok, user} = UserRepo.store(%User{}, %{name: "Jon", email: "jon@snow.com"})
    {:ok, user_2} = UserRepo.store(%User{}, %{name: "Adam", email: "adam@example.com"})
    SalaryRepo.store(%Salary{}, %{amount: 10, active: true, currency: :USD, user_id: user.id})
    SalaryRepo.store(%Salary{}, %{amount: 5, active: false, currency: :USD, user_id: user_2.id})
    {:ok, user: user, user_2: user_2}
  end

  describe "send email to active salary users" do
    test "sends email only to users with active salary", %{user: user} do
      SendEmailToActiveSalaryUsers.send_email_to_active_salary_users()

      assert_enqueued(
        worker: SendMultipleEmailsJob,
        args: %{users: [%{name: user.name, email: user.email}]},
        queue: :default
      )
    end
  end
end
