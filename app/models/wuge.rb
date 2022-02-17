class Wuge

  @@wuge_numbers = File.readlines(Rails.root.join("vendor/data/wuge_shuli.txt").to_s)
    .reduce Hash.new do |hash, line|
      m = line.match /^.+?(\d+).+：（(.+?)）(.+)（(.+)）/
      number = m[1].to_i
      hash[number] = { number: number, name: m[2], desc: m[3], level: m[4] }
      hash
    end.freeze

  @@sancai_configs = CSV.table(Rails.root.join("vendor/data/sancai.csv"))
    .reduce Hash.new do |hash, row|
      hash[row[:element]] = row.to_h
      hash
    end.freeze

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

  %w[tian ren di wai zong].each do |n|
    define_method "#{n}_wuxing".to_sym do
      calc_wuxing send(n)
    end

    define_method "#{n}_shuli".to_sym do
      calc_shuli send(n)
    end
  end

  def sancai
    element = %w[tian ren di].map { |n| send("#{n}_wuxing") }.join
    @@sancai_configs[element]
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

    def calc_wuxing(number)
      case number % 10
      when 1, 2 then "木"
      when 3, 4 then "火"
      when 5, 6 then "土"
      when 7, 8 then "金"
      when 9, 0 then "水"
      end
    end

    def calc_shuli(number)
      n = number % 81
      @@wuge_numbers[n == 0 ? 81 : n]
    end

end
