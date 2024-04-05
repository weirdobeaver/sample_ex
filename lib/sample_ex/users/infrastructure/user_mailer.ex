defmodule SampleEx.Users.Mailers.UserEmail do
  import Swoosh.Email

  @spec invite(%{:email => String.t(), :name => String.t()}) ::
          Swoosh.Email.t()
  def invite(user) do
    new()
    |> to({user.name, user.email})
    |> from({"Sansa Stark", "sansa@stark.com"})
    |> subject("Come to the party.")
    |> html_body("<h1>Hello #{user.name}</h1><p>Come to the party</p>")
    |> text_body("Hello #{user.name}\nCome to the party")
  end
end
