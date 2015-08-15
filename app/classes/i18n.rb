# Internationalization methods
class Internationalization

	class << self
		def full_path(file)
			path(file)
		end

		def file_url(file)
			path(file).file_url
		end

	  def path(file, add_resources_path=true)
			ident = NSLocale.currentLocale.localeIdentifier
	    lang = ident.split("_").first

			if file.resource_path.file_exists?
				# Regular file path
				file.resource_path
			elsif "#{lang}.lproj/#{file}".resource_path.file_exists?
				# Base language file
				"#{lang}.lproj/#{file}".resource_path
			elsif "#{lang}.lproj/#{Version.version}/#{file}".resource_path.file_exists?
				# Language version file
				"#{lang}.lproj/#{Version.version}/#{file}".resource_path
			elsif "en.lproj/#{Version.version}/#{file}".resource_path.file_exists?
				# en version falback
				"en.lproj/#{Version.version}/#{file}".resource_path
			elsif "#{lang}.lproj/2008/#{file}".resource_path.file_exists?
				# Language 2008 fallback
				"#{lang}.lproj/2008/#{file}".resource_path
			elsif "en.lproj/2008/#{file}".resource_path.file_exists?
				# en 2008 fallback
				"en.lproj/2008/#{file}".resource_path
			end
	  end
	end

end
