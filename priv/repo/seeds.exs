# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SampleEx.Repo.insert!(%SampleEx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SampleEx.Repo
alias SampleEx.Users.User
alias SampleEx.Users.Salary

batch_size = 1_000
currencies = [:USD, :EUR, :GBP, :PLN]

1..20
|> Enum.each(fn big_batch_index ->
  users =
    Enum.map(1..batch_size, fn index ->
      %{
        name: "Jon #{big_batch_index} #{index}",
        email: "jon#{index}@snow#{big_batch_index}.com",
        inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
        updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
      }
    end)

  {_, user_ids} = Repo.insert_all(User, users, returning: [:id])

  salaries_to_insert =
    Enum.flat_map(user_ids, fn user ->
      first_is_active = Enum.random([true, false])

      first_salary = %{
        user_id: user.id,
        amount: :rand.uniform(90_000_00),
        currency: Enum.random(currencies),
        active: first_is_active,
        inserted_at: DateTime.utc_now() |> DateTime.truncate(:microsecond),
        updated_at: DateTime.utc_now() |> DateTime.truncate(:microsecond)
      }

      second_activation_flag =
        case first_is_active do
          true ->
            false

          false ->
            Enum.random([true, false])
        end

      second_salary = %{
        user_id: user.id,
        amount: :rand.uniform(100_000_00),
        currency: Enum.random(currencies),
        active: second_activation_flag,
        inserted_at: DateTime.utc_now() |> DateTime.truncate(:microsecond),
        updated_at: DateTime.utc_now() |> DateTime.truncate(:microsecond)
      }

      [first_salary, second_salary]
    end)

  Repo.insert_all(Salary, salaries_to_insert)
end)
