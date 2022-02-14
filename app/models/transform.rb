class Transform

  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :from, :string
  attribute :to, :string
  attribute :config, :string

  validates :from, :config, presence: true
  validates :config, inclusion: { in: OpenCC::CONFIGS.map(&:to_s) }

end
