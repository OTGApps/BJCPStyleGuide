class Version
  class << self
    def version
      App::Persistence['style_version'] || "2015"
    end

    def set(v)
      App::Persistence['style_version'] = v
    end

    def version_2008?
      App::Persistence['style_version'] == "2008"
    end

    def version_2015?
      App::Persistence['style_version'] == "2015"
    end

    def toggle
      if version_2008?
        App::Persistence['style_version'] = "2015"
      else
        App::Persistence['style_version'] = "2008"
      end
    end

    def title
      if version_2008?
        I18n.t(:title_2008)
      else
        I18n.t(:title_2015)
      end
    end
  end
end
