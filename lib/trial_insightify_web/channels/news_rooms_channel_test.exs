defmodule TrialInsightifyWeb.NewsRoomsChannelTest do
  use TrialInsightifyWeb.ChannelCase

  setup do
    {:ok, _, socket} = socket(%{:user_id => 123})
    |> subscribe_and_join(TrialInsightifyWeb.NewsRoomsChannel, "news_rooms:lobby")
    {:ok, socket: socket}
  end

  test "ping replies with :ok", %{socket: socket} do
    push(socket, "ping", %{"hello" => "world"})
    assert_reply {:ok, %{"hello" => "world"}}
  end

  test "shout broadcasts to news_rooms:lobby", %{socket: socket} do
    push(socket, "shout", %{"hello" => "world"})
    assert_broadcast "shout", %{"hello" => "world"}
  end
end
