class Style

  PROPERTIES = [:id, :type, :category, :name, :transname, :aroma, :appearance, :flavor, :mouthfeel, :impression, :comments, :history, :ingredients, :comparison, :og, :fg, :ibu, :srm, :abv, :examples]
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
    t = "#{self.category}#{self.id.as_letter}: #{self.name}"
    t.insert(0, self.type) if Version.version_2015? && !self.type.nil?
    t
  end

  def subtitle
    self.transname
  end

  def html(property)
    return specs_html if property == :specs
    return "" unless respond_to? "#{property.to_s}="
    return "" if self.send(property).nil? || self.send(property) == ""

    if self.type == "C" && property == :aroma
      title = "<h2>Aroma/Flavor</h2>"
    else
      title = "<h2>#{property_title(property)}</h2>"
    end

    title << "<p>#{self.send(property)}</p>"
    title
  end

  def specs_html
    table = "<h2>" + I18n.t(:statistics) + "</h2>"
    li = ""
    table << "<ul>"
    %w(og fg ibu srm abv).each do |spec|
      li << "<li>" + spec.upcase + ": " + self.send(spec) + "</li>" unless self.send(spec).nil?
    end
    if li == ""
      ""
    else
      table << li << "</ul>"
      table
    end
  end

  def property_title(property)
    case property
    when :appearance, :aroma, :comments, :ingredients, :mouthfeel, :flavor, :history, :comparison
      I18n.t(property)
    when :impression
      I18n.t(:impression)
    when :examples
      I18n.t(:examples)
    end
  end

  def search_text
    search = ""
    %w(impression appearance ingredients examples aroma mouthfeel flavor transname comparison).each do |prop|
      search << (" " + self.send(prop)) unless self.send(prop).nil? || self.send(prop).downcase == "n/a"
    end
    search.split(/\W+/).uniq.join(" ")
  end

  def srm_range
    return nil if self.srm.nil? || self.srm.downcase == "n/a"
    self.srm.split(/\ ?-\ ?/) # gets 2-4 or 2 - 4
  end

end
