defmodule Twitter.Tweets.Tweet do
  use Ash.Resource, otp_app: :twitter, domain: Twitter.Tweets, data_layer: AshPostgres.DataLayer

  actions do
    defaults [:read, :destroy]
    create :create do
      accept [:text, :label, :user_id]
    end
    update :update, accept: [:text, :label]
  end

  attributes do
    uuid_primary_key :id
    attribute :text, :string do
      allow_nil? false
    end
    attribute :label, :string
    timestamps()
  end

  postgres do
    table "tweets"
    repo Twitter.Repo
  end

  relationships do
    belongs_to :user, Twitter.Accounts.User do
      allow_nil? false
    end

  end

end
