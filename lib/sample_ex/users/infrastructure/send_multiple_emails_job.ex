defmodule SampleEx.Users.Workers.SendMultipleEmailsJob do
  use Oban.Worker, queue: :default, tags: ["user_mailer"]

  alias SampleEx.Users.Workers.SendEmailJob

  @impl Oban.Worker

  @spec perform(Oban.Job.t()) :: :ok
  def perform(%Oban.Job{args: users}) do
    users["users"]
    |> Enum.each(fn user ->
      SendEmailJob.new(%{email: user["email"], name: user["name"]}) |> Oban.insert()
    end)
  end
end
