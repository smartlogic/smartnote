defmodule Web.QuestionView do
  use Web, :view

  def markdown(text) do
    {:ok, html, _} = Earmark.as_html(text, %Earmark.Options{code_class_prefix: "language-"})

    raw(html)
  end

  def tags(%{tags: tags}) do
    content_tag(:p, class: "text-sm italic") do
      Enum.join(tags, ", ")
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
