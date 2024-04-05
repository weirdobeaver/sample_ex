defmodule SampleEx.Users.Workers.SendEmailJobTest do
  use SampleEx.DataCase

  import Swoosh.TestAssertions

  alias SampleEx.Users.Workers.SendEmailJob
  alias SampleEx.Users.Mailers.UserEmail

  describe "perform" do
    test "enqueues email with correct params" do
      {:ok, _user} = perform_job(SendEmailJob, %{name: "Jon", email: "jon@snow.com"})
    end

    test "sends email with correct params" do
      perform_job(SendEmailJob, %{name: "Jon", email: "jon@snow.com"})
      assert_email_sent(UserEmail.invite(%{name: "Jon", email: "jon@snow.com"}))
    end
  end
end
