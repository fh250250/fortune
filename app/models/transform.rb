class Transform

  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :from, :string
  attribute :to, :string
  attribute :config, :string

  validates :from, :config, presence: true
  validates :config, inclusion: { in: OpenCC::CONFIGS.map(&:to_s) }

  def save
    return false unless valid?
    cc = OpenCC.create config.to_sym
    self.to = cc.convert from
    true
  rescue OpenCC::Error
    errors.add :base, "转换错误"
    false
  end

end
