kangxi_csv = CSV.table Rails.root.join("db/kangxi.csv")
kangxi_csv.each_with_index do |row, idx|
  puts "[kangxi] #{idx + 1} / #{kangxi_csv.size}"
  Kangxi.create row.to_h
end
