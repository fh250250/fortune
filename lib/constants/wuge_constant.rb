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

end
