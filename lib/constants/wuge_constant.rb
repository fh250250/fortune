module WugeConstant

  SHULI = File.readlines(Rails.root.join("vendor/data/wuge_shuli.txt").to_s)
    .reduce Hash.new do |hash, line|
      m = line.match /^.+?(\d+).+：（(.+?)）(.+)（(.+)）/
      number = m[1].to_i
      hash[number] = { number: number, name: m[2], desc: m[3], level: m[4] }
      hash
    end.freeze

  SANCAI = CSV.table(Rails.root.join("vendor/data/sancai.csv"))
    .reduce Hash.new do |hash, row|
      hash[row[:element]] = row.to_h
      hash
    end.freeze

  LUCKY_SHULI = [
    1, 3, 5, 6, 7, 8,
    11, 13, 15, 16, 17, 18,
    21, 23, 24, 25, 29,
    31, 32, 33, 35, 37, 39,
    41, 45, 47, 48,
    52, 57,
    61, 63, 65, 67, 68,
    81,
  ]

  LUCKY_SANCAI = [
    "木木木", "木木火", "木木土", "木火木", "木火土", "木水木", "木水金", "木水水",
    "火木木", "火木火", "火木土", "火火木", "火火土", "火土火", "火土土", "火土金",
    "土火木", "土火火", "土火土", "土土火", "土土土", "土土金", "土金土", "土金金", "土金水",
    "金土火", "金土土", "金土金", "金金土", "金水木", "金水金",
    "水木木", "水木火", "水木土", "水木水", "水金土", "水金水", "水水木", "水水金",
  ]

end
