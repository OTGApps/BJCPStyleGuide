class StylesScreen < ProMotion::SectionedTableScreen
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

  def table_data_index
    # Get the style number of the section
    table_data.collect do |section|
      section[:title].split(" ").first[0..-2]
    end
  end

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
    # ["Beer"] + beer_categories + ["Mead"] + mead_categories + ["Cider"] + cider_categories
    beer_categories + mead_categories + cider_categories
  end

  def section_title(section)
    "#{section['id']}: #{section["name"]}"
  end

  def subcategory_title(subcat)
    "#{subcat['id']}: #{subcat['name']}"
  end

  def subcategory_search_text(subcat)
    [subcat['impression'], subcat['appearance'], subcat['ingredients'], subcat['examples'], subcat['aroma'], subcat['mouthfeel'], subcat['flavor']].join(" ")
  end

  private

  # Return the subsection of the Hash object for a particular class of styles.
  # beer, mead, & cider are the current classes.
  def overall_category(name)
    this_class = @styles["styleguide"]["class"].select{|classes| classes["type"] == name }
    this_class.first["category"]
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
      @table_setup = nil
      update_table_data
    end
  end

end
