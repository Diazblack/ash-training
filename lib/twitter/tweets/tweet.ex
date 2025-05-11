defmodule Twitter.Tweets.Tweet do
  use Ash.Resource,
    otp_app: :twitter,
    domain: Twitter.Tweets,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshJsonApi.Resource]

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

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action(:create) do
      authorize_if always()
    end

    policy action(~w[update destroy]a) do
      authorize_if expr(user_id == ^actor(:id))
    end
  end

  attributes do
    uuid_primary_key :id do
      description "Primary id of the Resource"
      public? true
    end

    attribute :text, :string do
      description "The content of the tweet"
      allow_nil? false
      public? true
    end

    attribute :label, :string do
      description "Used to categorize each tweets"
      public? true
    end
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
    calculate :liked_by_me, :boolean, expr(exists(likes, user_id == ^actor(:id)))
  end

  aggregates do
    count :like_count, :likes

    first :user_email, :user, :email do
      authorize? false
    end
  end

  json_api do
    type "tweet"
  end
end
