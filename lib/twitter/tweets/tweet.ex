defmodule Twitter.Tweets.Tweet do
  use Ash.Resource, otp_app: :twitter, domain: Twitter.Tweets, data_layer: AshPostgres.DataLayer

  actions do
    defaults [:read, :destroy]
    create :create do
      accept [:text, :label]
      change relate_actor(:user)
      validate string_length(:text, max: 255)
    end
    update :update do
      accept [:text, :label]
      change relate_actor(:user)
      validate string_length(:text, max: 255)
    end

    read :feed do
      prepare build(sort: [inserted_at: :desc])
    end
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

    has_many :likes, Twitter.Tweets.Like
  end

  calculations do
    calculate :text_length, :integer, expr(string_length(text))
    calculate :liked_by_me, :boolean, expr(exists(likes, user_id ==^actor(:id)))
  end

  aggregates do
    count :like_count, :likes
    first :user_email, :user, :email
  end
end
