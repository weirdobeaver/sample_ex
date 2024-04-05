defmodule SampleEx.Users.Workers.SendMultipleEmailsJobTest do
  use SampleEx.DataCase

  alias SampleEx.Users.Workers.SendMultipleEmailsJob
  alias SampleEx.Users.Workers.SendEmailJob

  describe "perform" do
    test "returns ok and enques send email job in oban" do
      :ok = perform_job(SendMultipleEmailsJob, %{users: [%{name: "Jon", email: "jon@snow.com"}]})

      assert_enqueued(
        worker: SendEmailJob,
        args: %{name: "Jon", email: "jon@snow.com"},
        queue: :mailers
      )
    end

    test "enques multiple send email jobs in oban" do
      :ok =
        perform_job(SendMultipleEmailsJob, %{
          users: [
            %{name: "Jon", email: "jon@snow.com"},
            %{name: "Jon2", email: "jon2@snow.com"},
            %{name: "Jon3", email: "jon3@snow.com"}
          ]
        })

      assert_enqueued(
        worker: SendEmailJob,
        args: %{name: "Jon", email: "jon@snow.com"},
        queue: :mailers
      )

      assert_enqueued(
        worker: SendEmailJob,
        args: %{name: "Jon2", email: "jon2@snow.com"},
        queue: :mailers
      )

      assert_enqueued(
        worker: SendEmailJob,
        args: %{name: "Jon3", email: "jon3@snow.com"},
        queue: :mailers
      )
    end
  end
end
