class NameMaker

  include ActiveModel::API

  attr_accessor :surname

  validates :surname, presence: true

  def make
    return if invalid?
    calc_strokes_combines
  end

  private

    def surname_strokes
      return @surname_strokes if @surname_strokes

      traditional_surname = OpenCC.create(:s2t).convert @surname
      @surname_strokes = traditional_surname.chars.map { |c| Kangxi.find_by!(codepoint: c.ord).strokes }
      @surname_strokes
    end

    def calc_strokes_combines
      max_strokes = Kangxi.maximum :strokes
      combines = []
      tian = if surname_strokes.size > 1
        surname_strokes.sum
      else
        surname_strokes.first + 1
      end

      (1..max_strokes).each do |n1|
        (1..max_strokes).each do |n2|
          ren = surname_strokes.last + n1
          di = n1 + n2
          wai = tian + di - ren
          zong = surname_strokes.sum + n1 + n2
          # TODO 三才配置
          combines << [n1, n2] if [ren, di, wai, zong].all? { |ge| ge.in? WugeConstant::LUCKY_SHULI }
        end
      end

      combines
    end

end
