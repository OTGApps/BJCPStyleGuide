class Array
  def drop(n)
    n < 0 ? self[0...n] : super
  end
end

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
end

class Integer
  def as_letter
    return "" if self > 26
    ("A".."Z").to_a[self-1]
  end
end

# This has to be here or else you get the error:
# Objective-C stub for message `setPagingEnabled:' type `v@:c' not precompiled. Make sure you properly link with the framework or library that defines this message.
class DummyScrollView < UIScrollView
private
  def dummy
    setPagingEnabled(nil)
  end
end
