defmodule ExPesa.Mpesa.TokenServer do
  @moduledoc false

  use GenServer
  alias ExPesa.Mpesa.MpesaBase

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def get(pid \\ __MODULE__), do: GenServer.call(pid, :get)

  @impl true
  def init(token) do
    {:ok, token}
  end

  @impl true
  def handle_call(:get, _from, nil) do
    case MpesaBase.access_token() do
      {:ok, token} = result ->
        Process.send_after(self(), :clear, 3550000)
        {:reply, result, token}

      result ->
        {:reply, result, nil}
    end
  end

  def handle_call(:get, _from, token) do
    {:reply, {:ok, token}, token}
  end

  @impl true
  def handle_info(:clear, _token) do
    {:noreply, nil}
  end
end
