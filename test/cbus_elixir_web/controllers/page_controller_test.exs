defmodule CbusElixirWeb.PageControllerTest do
  use CbusElixirWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "What is Columbus Elixir"
  end

  test "Date Query String", %{conn: conn} do
    date = "2018-03-25"
    conn = get(conn, "/?date=#{date}")
    assert html_response(conn, 200) =~ "2018-04-03"
  end
end
