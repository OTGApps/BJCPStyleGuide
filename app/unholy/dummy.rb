# This has to be here or else you get the error:
# Objective-C stub for message `setPagingEnabled:' type `v@:c' not precompiled. Make sure you properly link with the framework or library that defines this message.
class DummyScrollView < UIScrollView
private
  def dummy
    setPagingEnabled(nil)
  end
end
