class CreateKangxis < ActiveRecord::Migration[7.0]
  def change
    create_table :kangxis do |t|
      t.integer :codepoint,         null: false, index: { unique: true }, comment: "码点"
      t.integer :strokes,           null: false, index: true,             comment: "笔画数"
      t.integer :radical_codepoint, null: false, index: true,             comment: "部首码点"
      t.integer :radical_strokes,   null: false, index: true,             comment: "部首笔画数"

      t.timestamps
    end
  end
end
