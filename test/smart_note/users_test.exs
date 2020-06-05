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
          info: %{
            email: "user@example.com",
            name: "John User"
          }
        })

      assert user.email == "user@example.com"
      assert user.name == "John User"
    end
  end
end
