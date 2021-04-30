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
    %{balance: user.balance, name: user.name, id: user.id, ssn: user.ssn, surname: user.surname}
  end

  def render("auth.json", %{token: token}) do
    %{token: token}
  end
end
