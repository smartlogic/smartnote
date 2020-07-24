defmodule Web.NoteView do
  use Web, :view

  alias Web.PaginationView

  def markdown(text) do
    {:ok, html, _} = Earmark.as_html(text, %Earmark.Options{code_class_prefix: "language-"})

    content_tag(:div, class: "markdown") do
      raw(html)
    end
  end

  def tags(%{tags: tags}) do
    content_tag(:p, class: "text-sm italic") do
      tags
      |> Enum.map(fn tag ->
        link(tag, to: Routes.tag_path(Web.Endpoint, :show, tag), class: "inline")
      end)
      |> Enum.intersperse(", ")
    end
  end

  def tags_value(changeset) do
    case Ecto.Changeset.get_field(changeset, :tags) do
      nil ->
        ""

      tags ->
        Enum.join(tags, ", ")
    end
  end
end
