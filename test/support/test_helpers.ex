defmodule SmartNote.TestHelpers do
  @moduledoc """
  Test Helpers for creating database records
  """

  alias SmartNote.Users

  def create_user(params \\ %{}) do
    params =
      Map.merge(
        %{
          email: "user@example.com",
          name: "John Smith"
        },
        params
      )

    Users.from_social(%{
      provider: :github,
      uid: 1,
      extra: %{
        raw_info: %{
          user: %{}
        }
      },
      info: params
    })
  end
end
