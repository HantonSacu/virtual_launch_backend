defmodule MpgSamsungLaunchSchemas.User do
  use MpgSamsungLaunchSchemas.Base

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    has_many :tokens, MpgSamsungLaunchSchemas.Token

    timestamps()
  end
end
