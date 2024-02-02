defmodule Kerching.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kerching.Accounts.Account

  schema "accounts" do
    field :name, :string

    belongs_to :parent, Account
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :parent_id])
    |> validate_required([:name])
  end
end
