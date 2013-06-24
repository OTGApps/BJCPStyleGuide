class Style

  PROPERTIES = [:id, :category, :name, :aroma, :appearance, :flavor, :mouthfeel, :impression, :comments, :history, :ingredients, :og, :fg, :ibu, :srm, :abv, :examples]
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

  def title
    "#{self.category}#{self.id.as_letter}: #{self.name}"
  end

  def html(property)
    return specs_html if property == :specs
    return "" unless respond_to? "#{property.to_s}="

    ap "got here"

    "<h2>#{property_title(property)}</h2>
     <p>#{self.send(property)}</p>"
  end

  def specs_html
    table = "<h2>Vital Statistics</h2>"
    %w(og fg ibu srm abv).each do |spec|
      table << "<li>" + spec.upcase + ": " + self.send(spec) + "</li>"
    end
    table
  end

  def property_title(property)
    case property
    when :appearance, :aroma, :comments, :ingredients, :mouthfeel, :flavor, :history
      property.to_s.titlecase
    when :impression
      "Overall Impression"
    when :examples
      "Commercial Examples"
    end
  end

  def search_text
    search = ""
    %w(impression appearance ingredients examples aroma mouthfeel flavor).each do |prop|
      search << (" " + self.send(prop)) unless self.send(prop).nil? || self.send(prop).downcase == "n/a"
    end
    search.split(/\W+/).uniq.join(" ")
  end

  def srm_range
    return nil if self.srm.nil? || self.srm.downcase == "n/a"
    self.srm.split(" - ")
  end

end
