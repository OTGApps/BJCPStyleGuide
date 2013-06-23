class Style

  PROPERTIES = [:id, :aroma, :stats, :impression, :name, :appearance, :comments, :ingredients, :examples, :mouthfeel, :flavor, :history]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(args={})
    args.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send("#{key}=", value)
      end
    }
  end

  def html(property)
    ap property
    return "" unless respond_to? "#{property.to_s}="
    return specs_html if property == :stats

    ap "got here"

    "<h2>#{title(property)}</h2>
     <p>#{self.send(property)}</p>"
  end

  def specs_html
    table = ""
    %w(og fg ibu srm abv).each do |stat|
      # unless self[:stats][stat].nil?
      #   table << "<li>" + stat.upcase + ": " + vital_stats_low_high(self[:stats][stat]) + "</li>"
      # end
    end
    table
  end

  def vital_stats_low_high(stat)
    if stat["flexible"] == "false"
      stat["low"] + "-" + stat["high"]
    else
      "N/A"
    end
  end

  def title(property)
    case property
    when :appearance, :aroma, :comments, :ingredients, :mouthfeel, :flavor, :history
      property.to_s.titlecase
    when :impression
      "Overall Impression"
    when :examples
      "Commercial Examples"
    end
  end

end
