class String
  def titlecase
    split(/(\W)/).map(&:capitalize).join
  end
end
