# Internationalization methods
class Internationalization

	class << self
		def full_path(file)
			Internationalization.path(file, true)
		end

		def resources_path(file)
			Internationalization.path(file, false)
		end

	  def path(file, add_resources_path=true)
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

end
