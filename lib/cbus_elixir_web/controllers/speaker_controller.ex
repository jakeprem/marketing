defmodule CbusElixirWeb.SpeakerController do
  use CbusElixirWeb, :controller

  alias CbusElixir.App
  alias CbusElixir.App.Speaker

  plug :authenticate, [usernames: ["admin",]] when action in [:index]


  def index(conn, _params) do
    speakers = App.list_speakers()
    render(conn, "index.html", speakers: speakers, admin: conn.assigns.admin)
  end

  def new(conn, _params) do
    changeset = App.change_speaker(%Speaker{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"speaker" => speaker_params}) do
    case App.create_speaker(speaker_params) do
      {:ok, speaker} ->
        conn
        |> put_flash(:info, "Speaker created successfully.")
        |> redirect(to: speaker_path(conn, :show, speaker))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    speaker = App.get_speaker!(id)
    render(conn, "show.html", speaker: speaker)
  end

  def edit(conn, %{"id" => id}) do
    speaker = App.get_speaker!(id)
    changeset = App.change_speaker(speaker)
    render(conn, "edit.html", speaker: speaker, changeset: changeset)
  end

  def update(conn, %{"id" => id, "speaker" => speaker_params}) do
    speaker = App.get_speaker!(id)

    case App.update_speaker(speaker, speaker_params) do
      {:ok, speaker} ->
        conn
        |> put_flash(:info, "Speaker updated successfully.")
        |> redirect(to: speaker_path(conn, :show, speaker))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", speaker: speaker, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    speaker = App.get_speaker!(id)
    {:ok, _speaker} = App.delete_speaker(speaker)

    conn
    |> put_flash(:info, "Speaker deleted successfully.")
    |> redirect(to: speaker_path(conn, :index))
  end

  defp authenticate(conn, options) do
    username = conn
      |> fetch_query_params()
      |> Map.get(:query_params)
      |> Map.get("username")

    isAdmin = username in options[:usernames]

    conn |> assign(:admin, isAdmin)

  end
end
