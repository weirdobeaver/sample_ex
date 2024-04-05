defmodule SampleExWeb.Api.V1.UsersControllerTest do
  @moduledoc false

  use SampleExWeb.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  alias SampleEx.Users.Repositories.UserRepo
  alias SampleEx.Users.Repositories.SalaryRepo
  alias SampleEx.Users.User
  alias SampleEx.Users.Salary

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("content-type", "application/json")

    {:ok, user} = UserRepo.store(%User{}, %{name: "Jon", email: "jon@snow.com"})
    {:ok, user_2} = UserRepo.store(%User{}, %{name: "Ned", email: "ned@stark.com"})
    {:ok, user_3} = UserRepo.store(%User{}, %{name: "Robb", email: "robb@stark.com"})

    {:ok, user_salary} =
      SalaryRepo.store(%Salary{}, %{user_id: user.id, amount: 10, currency: :USD, active: true})

    {:ok, user_2_salary} =
      SalaryRepo.store(%Salary{}, %{user_id: user_2.id, amount: 10, currency: :USD, active: true})

    {:ok, user_3_salary} =
      SalaryRepo.store(%Salary{}, %{user_id: user_3.id, amount: 10, currency: :USD, active: true})

    {:ok,
     conn: conn,
     user: user,
     user_2: user_2,
     user_3: user_3,
     user_salary: user_salary,
     user_2_salary: user_2_salary,
     user_3_salary: user_3_salary}
  end

  describe "index" do
    test "Returns multiple users",
         %{conn: conn, user: user, user_salary: user_salary} do
      content =
        conn
        |> get("/api/v1/users", %{})
        |> json_response(200)

      assert length(content["data"]) == 3

      assert Enum.member?(content["data"], %{
               "name" => user.name,
               "salary" => %{
                 "amount" => to_string(user_salary.amount),
                 "currency" => to_string(user_salary.currency)
               }
             })

      api_spec = SampleExWeb.ApiSpec.spec()
      assert_schema(content, "Users", api_spec)
    end

    test "Returns multiple users ordered by name",
         %{conn: conn, user: user, user_salary: user_salary} do
      UserRepo.store(%User{}, %{name: "Adam", email: "adam@example.com"})

      content =
        conn
        |> get("/api/v1/users", %{})
        |> json_response(200)

      assert length(content["data"]) == 4

      assert List.first(content["data"])["name"] == "Adam"
      assert Enum.at(content["data"], 1)["name"] == "Jon"
      assert Enum.at(content["data"], 2)["name"] == "Ned"
      assert Enum.at(content["data"], 3)["name"] == "Robb"

      assert Enum.member?(content["data"], %{
               "name" => user.name,
               "salary" => %{
                 "amount" => to_string(user_salary.amount),
                 "currency" => to_string(user_salary.currency)
               }
             })

      api_spec = SampleExWeb.ApiSpec.spec()
      assert_schema(content, "Users", api_spec)
    end

    test "Returns users by name",
         %{conn: conn, user: user, user_salary: user_salary} do
      content =
        conn
        |> get("/api/v1/users", %{name: "Jon"})
        |> json_response(200)

      assert length(content["data"]) == 1

      assert Enum.member?(content["data"], %{
               "name" => user.name,
               "salary" => %{
                 "amount" => to_string(user_salary.amount),
                 "currency" => to_string(user_salary.currency)
               }
             })
    end

    test "Returns users by email",
         %{conn: conn, user: user, user_salary: user_salary} do
      content =
        conn
        |> get("/api/v1/users", %{email: "jon@snow.com"})
        |> json_response(200)

      assert length(content["data"]) == 1

      assert Enum.member?(content["data"], %{
               "name" => user.name,
               "salary" => %{
                 "amount" => to_string(user_salary.amount),
                 "currency" => to_string(user_salary.currency)
               }
             })
    end

    test "Returns users by name and email",
         %{conn: conn, user: user, user_salary: user_salary} do
      UserRepo.store(%User{}, %{name: "Jon", email: "jon2@snow.com"})

      content =
        conn
        |> get("/api/v1/users", %{name: "Jon", email: "jon@snow.com"})
        |> json_response(200)

      assert length(content["data"]) == 1

      assert Enum.member?(content["data"], %{
               "name" => user.name,
               "salary" => %{
                 "amount" => to_string(user_salary.amount),
                 "currency" => to_string(user_salary.currency)
               }
             })
    end

    test "Returns error when filter parameters are wrong", %{conn: conn} do
      content =
        conn
        |> get("/api/v1/users", %{wrong: "wrong"})
        |> json_response(422)

      error = content["errors"] |> hd()
      assert error["detail"] == "Unexpected field: wrong"
    end
  end
end
