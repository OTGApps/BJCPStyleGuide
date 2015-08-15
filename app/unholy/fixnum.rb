class Fixnum
  def as_letter
    return "" if self > 26
    ("A".."Z").to_a[self-1]
  end
end
