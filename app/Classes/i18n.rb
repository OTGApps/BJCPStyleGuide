# Internationalization methods
class Internationalization

	def self.full_path(file)
		Internationalization.path(file, true)
	end

	def self.resources_path(file)
		Internationalization.path(file, false)
	end

  def self.path(file, add_resources_path=true)
    resources = (add_resources_path == true) ? App.resources_path : ""

    ident = NSLocale.currentLocale.localeIdentifier
    lang = ident.split("_").first

    current_locale_file = File.join(resources, "#{lang}.lproj", file)

    if File.exist? File.join(App.resources_path, "#{lang}.lproj", file)
      current_locale_file
    else
      File.join(resources, "en.lproj", file)
    end
  end

end

class NSString
  def _localized(value=nil, table=nil)
    path = NSBundle.mainBundle.pathForResource("Localizable", ofType:"strings", inDirectory:nil, forLocalization:NSLocale.currentLocale.localeIdentifier.split("_").first) || NSBundle.mainBundle.pathForResource("Localizable", ofType:"strings", inDirectory:nil, forLocalization:"en")
    dict = NSDictionary.dictionaryWithContentsOfFile path
    dict.objectForKey self
  end
  alias __ _localized
end