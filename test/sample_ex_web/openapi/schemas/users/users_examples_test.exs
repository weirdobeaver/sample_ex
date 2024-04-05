defmodule SampleExWeb.OpenApi.Schemas.Users.UsersExamplesTest do
  use ExUnit.Case, async: true

  import OpenApiSpex.TestAssertions

  alias SampleExWeb.OpenApi.Schemas.User.Users

  test "Users response schema example match the defined schema" do
    api_spec = SampleExWeb.ApiSpec.spec()

    assert_schema(
      Users.schema().example,
      Users.schema().title,
      api_spec
    )
  end
end
