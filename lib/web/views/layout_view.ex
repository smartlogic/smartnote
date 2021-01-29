defmodule Web.LayoutView do
  use Web, :view

  import Web.Gettext, only: [gettext: 1]

  def search_term(conn) do
    conn.assigns[:search_term]
  end

  def question_header_text(conn) do
    search_term = Web.LayoutView.search_term(conn)

    if is_nil(search_term) do
      "Questions"
    else
      "Questions matching '#{search_term}'"
    end
  end
end
