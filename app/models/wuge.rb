class Wuge

  include ActiveModel::API

  attr_accessor :surname, :name
  attr_reader :traditional_surname, :traditional_name
  attr_reader :surname_strokes, :name_strokes

  validates :surname, :name, presence: true

  def initialize(attributes = {})
    super
    prepare_data
  end

  def tian
    if @surname_strokes.size > 1
      @surname_strokes.sum
    else
      @surname_strokes.first + 1
    end
  end

  def ren
    @surname_strokes.last + @name_strokes.first
  end

  def di
    if @name_strokes.size > 1
      @name_strokes.sum
    else
      @name_strokes.first + 1
    end
  end

  def wai
    tian + di - ren
  end

  def zong
    @surname_strokes.sum + @name_strokes.sum
  end

  def full_name
    "#{@surname}#{@name}"
  end

  def traditional_full_name
    "#{@traditional_surname}#{@traditional_name}"
  end

  private

    def prepare_data
      return unless valid?
      cc = OpenCC.create :s2t
      @traditional_surname = cc.convert(@surname)
      @traditional_name    = cc.convert(@name)
      @surname_strokes     = @traditional_surname.chars.map { |c| Kangxi.find_by!(codepoint: c.ord).strokes }
      @name_strokes        = @traditional_name.chars.map    { |c| Kangxi.find_by!(codepoint: c.ord).strokes }
    rescue ActiveRecord::RecordNotFound
      @errors.add :base, "康熙字典未查到"
    rescue OpenCC::Error
      @errors.add :base, "繁简转换错误"
    end

end
