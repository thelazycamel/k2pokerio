defmodule K2pokerIoWeb do
  @moduledoc """


  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use K2pokerIo.Web, :controller
      use K2pokerIo.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.


  Do NOT define functions inside the quoted expressions
  below.
  """

  def data do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: K2pokerIoWeb

      alias K2pokerIo.Repo
      alias K2pokerIoWeb.Router.Helpers, as: Routes

      import Ecto
      import Ecto.Query

      import K2pokerIoWeb.Gettext
      import K2pokerIoWeb.Helpers.Session, only: [current_user: 1, logged_in?: 1]
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/k2poker_io_web/templates", namespace: K2pokerIoWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]
      import K2pokerIoWeb.Helpers.Session, only: [current_user: 1, logged_in?: 1]
      import K2pokerIoWeb.Helpers.FriendsHelper, only: [friend_requests: 1]

      alias K2pokerIoWeb.Router.Helpers, as: Routes

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import K2pokerIoWeb.ErrorHelpers
      import K2pokerIoWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias K2pokerIo.Repo
      import Ecto
      import Ecto.Query
      import K2pokerIoWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
