defmodule SampleEx.Users.Workers.SendEmailJob do
  use Oban.Worker, queue: :mailers, tags: ["user_mailer"]

  alias SampleEx.Users.Mailers.UserEmail

  @impl Oban.Worker

  @spec perform(Oban.Job.t()) :: {:error, :econnrefused | :invalid_attrs} | {:ok, binary()}
  def perform(%Oban.Job{args: args}) do
    UserEmail.invite(%{email: args["email"], name: args["name"]})
    |> SampleEx.Mailer.deliver()
  end
end
