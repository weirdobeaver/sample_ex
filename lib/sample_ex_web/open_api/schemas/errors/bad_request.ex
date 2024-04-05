defmodule SampleExWeb.OpenApi.Schemas.Errors.BadRequest do
  @moduledoc false

  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "BadRequest",
    description: "Bad parameters provided",
    type: :object,
    properties: %{
      code: %Schema{type: :string, enum: [:bad_request], description: "Error code"},
      errors: %Schema{type: :array, items: %Schema{type: :object}, description: "Error objects"},
      message: %Schema{type: :string, description: "Error message"}
    },
    required: [:code, :message],
    example: %{
      "code" => "bad_request",
      "errors" => [],
      "message" => "Bad parameters provided"
    }
  })
end
