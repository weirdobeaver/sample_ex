defmodule SampleExWeb.Api.V1.UsersController do
  use SampleExWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias SampleExWeb.OpenApi.Schemas.User.Users
  alias SampleExWeb.OpenApi.Schemas.Errors.BadRequest
  alias SampleExWeb.OpenApi.Schemas.User.InviteUsersResponse
  alias SampleExWeb.Api.V1.Users.UsersJson
  alias SampleEx.Users.Services.ListUsersWithActiveSalary
  alias SampleEx.Users.Services.SendEmailToActiveSalaryUsers

  tags(["users"])

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  operation(:index,
    operation_id: "ListUsers",
    summary: "List users with active salaries",
    parameters: [
      name: [
        in: :query,
        description: "User name filtering",
        type: :string,
        example: "John",
        required: false
      ],
      email: [
        in: :query,
        description: "User email filtering",
        type: :string,
        example: "jon@snow.com",
        required: false
      ]
    ],
    responses: [
      ok: {"List of users", "application/json", Users},
      bad_request: {"Bad parameters", "application/json", BadRequest}
    ]
  )

  def index(conn, params) do
    filters = %{name: params[:name], email: params[:email]}

    users = ListUsersWithActiveSalary.list_users_with_last_active_salary(filters)
    json(conn, UsersJson.response(users))
  end

  operation(:invite_users,
    operation_id: "InviteUsers",
    summary: "Sends email to users with active salaries",
    responses: [
      ok: {"Emails sent", "application/json", InviteUsersResponse}
    ]
  )

  def invite_users(conn, _) do
    SendEmailToActiveSalaryUsers.send_email_to_active_salary_users()
    json(conn, %{code: :ok})
  end
end
