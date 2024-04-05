defmodule SampleExWeb.OpenApi.Schemas.User.Users do
  @moduledoc false

  require OpenApiSpex
  alias SampleExWeb.OpenApi.Schemas.User.User
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Users",
    description: "List of users with active salaries",
    type: :object,
    properties: %{
      data: %Schema{type: :array, items: User}
    },
    required: [:data],
    example: %{
      "data" => [User.schema().example]
    }
  })
end
