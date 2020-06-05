defmodule ConductorWeb.Admin.RedirectController do
  use ConductorWeb, :controller

  alias Conductor.{Repo, Redirect}
  import Ecto.Query

  def index(conn, params) do
    page =
      Redirect
      |> order_by(desc: :inserted_at)
      |> Conductor.Repo.paginate(params)

    render(conn, "index.html", redirects: page.entries, page_number: page.page_number)
  end

  def new(conn, _params) do
    changeset = Redirect.changeset(%Redirect{})

    render(conn, "new.html",
      changeset: changeset,
      action: Routes.admin_redirect_path(conn, :create)
    )
  end

  def edit(conn, %{"id" => id}) do
    redirect = Repo.get(Redirect, id)

    if redirect do
      changeset = Redirect.changeset(redirect)

      render(conn, "edit.html",
        changeset: changeset,
        action: Routes.admin_redirect_path(conn, :update, redirect.id)
      )
    else
      {:error, :not_found}
    end
  end

  def show(conn, %{"id" => id}) do
    redirect = Repo.get(Redirect, id)

    if redirect do
      render(conn, "show.html", redirect: redirect)
    else
      {:error, :not_found}
    end
  end

  def create(conn, %{"redirect" => params}) do
    changeset = Redirect.changeset(%Redirect{}, redirect_params(params))

    case Repo.insert(changeset) do
      {:ok, redirect} ->
        conn
        |> put_flash(:info, "The redirect has been created.")
        |> redirect(to: Routes.admin_redirect_path(conn, :show, redirect.id))

      {:error, changeset} ->
        conn
        |> render("new.html",
          changeset: changeset,
          action: Routes.admin_redirect_path(conn, :create)
        )
    end
  end

  def update(conn, %{"id" => id, "redirect" => params}) do
    redirect = Repo.get(Redirect, id)
    changeset = Redirect.changeset(redirect, redirect_params(params))

    case Repo.update(changeset) do
      {:ok, changeset} ->
        conn
        |> put_flash(:info, "The redirect has been updated.")
        |> redirect(to: Routes.admin_redirect_path(conn, :show, redirect.id))

      {:error, changeset} ->
        conn
        |> render("edit.html",
          changeset: changeset,
          action: Routes.admin_redirect_path(conn, :update, redirect.id)
        )
    end
  end

  defp redirect_params(params) do
    StrongParams.extract(params, ["code", "destination", "name", "active"])
  end
end
