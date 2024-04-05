defmodule SampleEx.Users.Services.SendEmailToActiveSalaryUsers do
  alias SampleEx.Users.Repositories.UserRepo
  alias SampleEx.Users.Workers.SendMultipleEmailsJob

  @spec send_email_to_active_salary_users() :: {:error, any()} | {:ok, Oban.Job.t()}
  def send_email_to_active_salary_users() do
    users = UserRepo.list_users_with_active_salary()
    user_list = Enum.map(users, fn user -> %{email: user.email, name: user.name} end)

    SendMultipleEmailsJob.new(%{users: user_list})
    |> Oban.insert()
  end
end
