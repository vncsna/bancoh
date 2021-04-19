defmodule BancohWeb.UserView do
  use BancohWeb, :view
  alias BancohWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      ssn: user.ssn,
      name: user.name,
      surname: user.surname,
      balance: user.balance}
  end
end
