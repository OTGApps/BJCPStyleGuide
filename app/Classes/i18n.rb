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
    current_locale_file = File.join(resources, "i18n", NSLocale.currentLocale.localeIdentifier, file)

    if File.exist? current_locale_file
      current_locale_file
    else
      File.join(resources, "i18n", "en_US", file)
    end
  end

end