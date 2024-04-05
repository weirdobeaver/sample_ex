defmodule SampleExWeb.Api.V1.Users.UsersJson do
  def response(users) do
    user_list =
      users
      |> Enum.map(fn user ->
        %{
          name: user.user.name,
          salary: format_salary(user.salary)
        }
      end)

    %{data: user_list}
  end

  defp format_salary(nil), do: %{}
  defp format_salary(salary), do: %{currency: salary.currency, amount: salary.amount}
end
