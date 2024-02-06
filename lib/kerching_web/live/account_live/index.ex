defmodule KerchingWeb.AccountLive.Index do
  use KerchingWeb, :live_view

  alias Kerching.Accounts
  alias Kerching.Accounts.Account

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :accounts, Accounts.list_accounts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket =
      socket
      |> assign(:page_title, "Edit Account")
      |> assign(:tree, build_tree(Accounts.list_accounts()))
      |> assign(:account, Accounts.get_account!(id))

    # Need to redo next bit to get the actual parent_name BUT take into 
    # accoun the fact it might be nil
    assign(socket, :parent_name, set_parent_name(socket.assigns))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Account")
    |> assign(:tree, build_tree(Accounts.list_accounts()))
    |> assign(:account, %Account{})
    |> assign(:parent_name, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Accounts")
    |> assign(:account, nil)
  end

  @impl true
  def handle_info({KerchingWeb.AccountLive.FormComponent, {:saved, account}}, socket) do
    {:noreply, stream_insert(socket, :accounts, account)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    account = Accounts.get_account!(id)
    {:ok, _} = Accounts.delete_account(account)

    {:noreply, stream_delete(socket, :accounts, account)}
  end

  def set_parent_name(assigns) do
    case assigns.account.parent_id do
      nil -> "Top Level"
      _ -> assigns.account.parent.name
    end
  end

  def add_children(list, node) do
    %{
      id: node.id,
      name: node.name,
      children:
        Enum.filter(list, &(&1.parent_id == node.id))
        |> Enum.map(&add_children(list, &1))
    }
  end

  def build_tree(list) do
    dbg(list)
    accounts = Enum.filter(list, &is_nil(&1.parent_id)) |> Enum.map(&add_children(list, &1))
    dbg(accounts)

    [
      %{
        id: nil,
        name: "Top Level",
        children: []
      }
      | accounts
    ]
    |> dbg
  end
end
