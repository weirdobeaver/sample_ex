defmodule SampleExWeb.OpenApi.Schemas.User.InviteUsersResponse do
  @moduledoc false

  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "InviteUsersResponse",
    description: "Response after sending emails to users",
    type: :object,
    properties: %{
      code: %Schema{type: :string, enum: [:ok], description: "OK"}
    },
    required: [:code],
    example: %{
      "code" => :ok
    }
  })
end
