class ApplicationStylesheet < RubyMotionQuery::Stylesheet

  def application_setup
    # An example of setting standard fonts and colors
    font_family = 'Helvetica Neue'
    font.add_named :large,    font_family, 24
    font.add_named :medium,   font_family, 18
    font.add_named :small,    font_family, 12

    color.add_named :tint, '#E71C29'
    color.add_named :translucent_black, color(0, 0, 0, 0.4)
    color.add_named :battleship_gray,   '#7F7F7F'

    # StandardAppearance.apply app.window
  end

end
