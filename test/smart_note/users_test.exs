defmodule SmartNote.UsersTest do
  use SmartNote.DataCase
  use Bamboo.Test

  alias SmartNote.Users

  describe "creating new users" do
    test "from github" do
      {:ok, user} =
        Users.from_social(%{
          provider: :github,
          uid: 1,
          extra: %{
            raw_info: %{
              user: %{}
            }
          },
          info: %{
            nickname: "smith"
          }
        })

      assert user.username == "smith"
    end
  end
end
