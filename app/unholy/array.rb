class Array
  def drop(n)
    n < 0 ? self[0...n] : super
  end
end
