class String
  def titlecase
    split(/(\W)/).map(&:capitalize).join
  end

  def as_integer
    number = self.upcase.tr("A-Z", "1-9a-q").to_i(27)
    number -= 1 if number > 27
    return number
  end

  def image
    UIImage.imageNamed(self)
  end
  alias :uiimage :image
end
