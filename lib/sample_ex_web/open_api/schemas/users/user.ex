defmodule SampleExWeb.OpenApi.Schemas.User.User do
  @moduledoc false

  require OpenApiSpex
  alias SampleExWeb.OpenApi.Schemas.User.Salary
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "User",
    description: "Single user specification",
    type: :object,
    properties: %{
      name: %Schema{type: :string, description: "User name"},
      salary: Salary
    },
    required: [
      :name,
      :salary
    ],
    example: %{
      "name" => "John",
      "salary" => Salary.schema().example
    }
  })
end
