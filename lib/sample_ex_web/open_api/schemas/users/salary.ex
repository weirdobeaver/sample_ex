defmodule SampleExWeb.OpenApi.Schemas.User.Salary do
  @moduledoc false

  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Salary",
    description: "Single salary specification",
    type: :object,
    properties: %{
      currency: %Schema{type: :string, description: "Salary currency"},
      amount: %Schema{type: :number}
    },
    example: %{
      "currency" => "USD",
      "amount" => "10.00"
    }
  })
end
