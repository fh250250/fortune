class Kangxi < ApplicationRecord

  validates :codepoint, :strokes, :radical_codepoint, :radical_strokes, presence: true
  validates :codepoint, uniqueness: true

end
