class Fixnum
  def as_letter
    return "" if self > 26
    ("A".."Z").to_a[self-1]
  end

  def as_type
    if self == 2
      "M"
    elsif self == 3
      "C"
    end
  end
end
