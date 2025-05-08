defmodule Twitter.Tweets.Tweet do
  use Ash.Resource, otp_app: :twitter, domain: Twitter.Tweets, data_layer: AshPostgres.DataLayer

  actions do
    defaults [:read, :destroy]
    create :create do
      accept [:text]
    end
    update :update, accept: [:text]
  end

  attributes do
    uuid_primary_key :id
    attribute :text, :string
    timestamps()
  end

  postgres do
    table "tweets"
    repo Twitter.Repo
  end
end
