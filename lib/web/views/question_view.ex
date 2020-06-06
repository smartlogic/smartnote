defmodule Web.QuestionView do
  use Web, :view

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

  def render("libraries.html", %{question: %{libraries: libraries}})
      when is_nil(libraries) or libraries == "" do
    nil
  end

  def render("libraries.html", %{question: %{libraries: libraries}}) do
    libraries = String.split(libraries, "\n")

    content_tag(:div, class: "w-full") do
      [
        content_tag(:p, "Libraries", class: "text-xl"),
        content_tag(:ul) do
          render_many(libraries, __MODULE__, "library.html", as: :library)
        end
      ]
    end
  end

  def render("library.html", %{library: library}) do
    [repository | [library | version]] = String.split(library, " ")
    version = Enum.join(version, " ")

    case repository do
      "hex" ->
        content_tag(:li) do
          link("#{library} #{version}",
            to: "https://hex.pm/packages/#{library}",
            class: "text-blue-500"
          )
        end

      "npm" ->
        content_tag(:li) do
          link("#{library} #{version}",
            to: "https://www.npmjs.com/packages/#{library}",
            class: "text-blue-500"
          )
        end
    end
  end
end
