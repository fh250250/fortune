class Wuge

  include ActiveModel::API

  attr_accessor :surname, :name
  attr_reader :traditional_surname, :traditional_name
  attr_reader :tian, :ren, :di, :wai, :zong

  validates :surname, :name, presence: true

  def full_name
    "#{@surname}#{@name}"
  end

  def full_traditional_name
    "#{@traditional_surname}#{@traditional_name}"
  end

  def calc
    return false unless valid?
    s2t_convert
    calc_tian
    calc_ren
    calc_di
    calc_wai
    calc_zong
    true
  rescue ActiveRecord::RecordNotFound
    @errors.add :base, "康熙字典未查到"
    false
  rescue OpenCC::Error
    @errors.add :base, "繁简转换错误"
    false
  end

  private

    def s2t_convert
      cc = OpenCC.create :s2t
      @traditional_surname = cc.convert @surname
      @traditional_name = cc.convert @name
    end

    def find_kangxi_strokes(str)
      kx = Kangxi.find_by! codepoint: str.ord
      kx.strokes
    end

    def calc_tian
      if @traditional_surname.size > 1
        @tian = @traditional_surname.chars.sum { |c| find_kangxi_strokes c }
      else
        @tian = find_kangxi_strokes(@traditional_surname) + 1
      end
    end

    def calc_ren
      @ren = find_kangxi_strokes(@traditional_surname.last) + find_kangxi_strokes(@traditional_name.first)
    end

    def calc_di
      if @traditional_name.size > 1
        @di = @traditional_name.chars.sum { |c| find_kangxi_strokes c }
      else
        @di = find_kangxi_strokes(@traditional_name) + 1
      end
    end

    def calc_wai
      @wai = @tian + @di - @ren
    end

    def calc_zong
      @zong = full_traditional_name.chars.sum { |c| find_kangxi_strokes c }
    end

end
