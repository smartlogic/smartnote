defmodule SmartNote.Emails do
  @moduledoc false

  use Bamboo.Phoenix, view: SmartNote.Emails.EmailView

  import Web.Gettext, only: [gettext: 1]

  def welcome_email(user) do
    base_email()
    |> to(user.email)
    |> subject("Welcome to #{gettext("SmartNote")}!")
    |> render(:welcome)
  end

  defp base_email() do
    new_email()
    |> from("no-reply@smartnote.dev")
  end

  defmodule EmailView do
    @moduledoc false

    use Phoenix.View, root: "lib/smart_note/emails/templates", path: ""
    use Phoenix.HTML

    import Web.Gettext, only: [gettext: 1]
  end
end
