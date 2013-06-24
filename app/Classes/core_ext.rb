class Array
  def drop(n)
    n < 0 ? self[0...n] : super
  end
end

class String
  def titlecase
    split(/(\W)/).map(&:capitalize).join
  end
end

class Integer
  def as_letter
    return "" if self > 26
    ("A".."Z").to_a[self-1]
  end
end
