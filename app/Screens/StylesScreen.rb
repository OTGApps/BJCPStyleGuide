class StylesScreen < ProMotion::SectionedTableScreen
  title "Back"
  searchable :placeholder => "Search Styles"

  def will_appear
    self.setTitle("BJCP", subtitle:"2008 Style Guidelines")

    set_attributes self.view, {
      backgroundColor: UIColor.whiteColor
    }

    set_nav_bar_right_button UIImage.imageNamed("info.png"), action: :open_info_screen

    read_xml
  end

  def table_data
  	# @table_setup ||= begin
      s = []

      sections.each do |section|
        if section.is_a? String
          s << {
            title: section,
            cells: []
          }
        else
          s << {
            title: section["name"],
            cells: build_subcategories(section["subcategory"])
          }
        end
    	end

      s
    # end
  end

  def build_subcategories(params)
    c = []
    params = [params] if params.is_a?(Hash) # Support categories with only one subcategory
    params.each do |subcat|
      c << {
        title: "#{subcat['id']}: #{subcat['name']}"
      }
    end
    ap c
    c
  end

  def read_xml
    @done_read_xml ||= begin
      style_path = File.join(App.resources_path, "styleguide2008.xml")
      styles = File.read(style_path)

      error_ptr = Pointer.new(:object)
      style_hash = TBXML.dictionaryWithXMLData(styles.dataUsingEncoding(NSUTF8StringEncoding), error: error_ptr)
      error = error_ptr[0]
      $stderr.puts "Error when reading data: #{error}. Did you run 'rake bootstrap'?" unless error.nil?

      @styles = style_hash
      update_table_data
    end
  end

  def build_cells(path)
      c = []
    	section_listing(path).each do |style|
        c << {
    			title: style,
          cell_identifier: "StyleCell",
    			action: :open_style,
    			arguments: {:path => File.join(guidelines_path, path, style), :name => style}
    		}
    	end
  	 c
  end

  # def table_data_index
  #   table_data.collect do |section|
  #     first = section[:title].split(" ").first
  #     if ("A".."Z").to_a.include? first[0].upcase
  #       first[0]
  #     else
  #       first.to_i.to_s
  #     end
  #   end
  # end

  def open_style(args={})
  	open DetailScreen.new(args)
  end

  def open_info_screen(args={})
    open AboutScreen.new modal:true, nav_bar:true
  end

  def beer_categories
    overall_category "beer"
  end

  def mead_categories
    overall_category "mead"
  end

  def cider_categories
    overall_category "cider"
  end

  def sections
  	return [] if @styles.nil?
    ["Beer"] + beer_categories + ["Mead"] + mead_categories + ["Cider"] + cider_categories
  end

  private
  def overall_category(name)
    # ap @styles["styleguide"]["class"]
    this_class = @styles["styleguide"]["class"].select{|classes| classes["type"] == name }
    this_class.first["category"]
  end

end
