defmodule ExPesa.Mpesa.TokenServerTest do
  @moduledoc false

  import Tesla.Mock
  use ExUnit.Case, async: true
  alias ExPesa.Mpesa.TokenServer

  @token "SGWcJPtNtYNPGm6uSYR9yPYrAI3Bm"

  setup do
    mock_global(fn
      %{
        url: "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
        method: :get
      } ->
        %Tesla.Env{
          status: 200,
          body: %{
            "access_token" => @token,
            "expires_in" => "3599"
          }
        }
    end)

    :ok
  end

  test "the server is started in the application tree" do
    assert GenServer.whereis(TokenServer)
  end

  test "get/1 fetches and stores a new token if there was none initially" do
   {:ok, token} = TokenServer.get()
   assert token == @token
  end

  test "get/1 returns the token stored in the genserver" do
    token = "abcdef"
    {:ok, pid} = GenServer.start_link(TokenServer, token)
    {:ok, retrieved_token} = TokenServer.get(pid)
    assert token == retrieved_token
  end
end
