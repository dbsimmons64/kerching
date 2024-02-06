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

  def update_changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :parent_id])
    |> validate_required([:name])
    |> validate_parent_id()
  end

  @doc """
  Ensure that the account doesn't set itself as the parent.
  """
  def validate_parent_id(changeset) do
    if fetch_field!(changeset, :id) == fetch_field!(changeset, :parent_id) do
      add_error(changeset, :parent_id, "parent cannot be the same as account")
    else
      changeset
    end
  end
end
