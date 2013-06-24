class MainScreen < ProMotion::SectionedTableScreen
  title "2008 BJCP Styles"
  searchable :placeholder => "Search Styles"

  def will_appear
    @view_set_up ||= begin
      set_attributes self.view, { backgroundColor: UIColor.whiteColor }

      unless Device.ipad?
        set_nav_bar_right_button UIImage.imageNamed("info.png"), action: :open_info_screen
      end

      backBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Back", style:UIBarButtonItemStyleBordered, target:nil, action:nil)
      self.navigationItem.backBarButtonItem = backBarButtonItem;

      read_data
    end
  end

  def on_appear
    toolbar_animated = Device.ipad? ? false : true
    self.navigationController.setToolbarHidden(true, animated:toolbar_animated)
  end

  def table_data
    return [] if @styles.nil?
    @table_setup ||= begin
      s = []

      s << {
        title: "Introductions",
        cells: [
          intro_cell("Beer Introduction"),
          intro_cell("Mead Introduction"),
          intro_cell("Cider Introduction")
        ]
      }

      @styles.each do |section|
        s << {
          title: "#{section[:id]}: #{section[:name]}",
          cells: build_subcategories(section)
        }
      end
      s
    end
  end

  def intro_cell(name)
    {
      title: name,
      cell_identifier: "IntroductionCell",
      action: :open_intro_screen,
      arguments: {:file => "#{name}.html", :title => name}
    }
  end

  def build_subcategories(section)
    c = []

    # Support categories with only one subcategory
    # params = [params] if params.is_a?(Hash)
    section[:substyles].each do |subcat|
      c << {
        title: subcat.title,
        search_text: subcat.search_text,
        cell_identifier: "SubcategoryCell",
        action: :open_style,
        arguments: {:style => subcat}
      }
    end
    c
  end

  def table_data_index
    return if table_data.count < 1
    # Get the style number of the section
    ["{search}", "?"] + table_data.drop(1).collect do |section|
      section[:title].split(" ").first[0..-2]
    end
  end

  def open_style(args={})
    # self.navigationItem.title = "Back"
    if Device.ipad?
      open DetailScreen.new(args), nav_bar:true, in_detail: true
    else
      open DetailScreen.new(args)
    end
  end

  def open_info_screen(args={})
    open_modal AboutScreen.new(external_links: true),
      nav_bar: true,
      presentation_style: UIModalPresentationFormSheet
  end

  def open_intro_screen(args={})
    if Device.ipad?
      open IntroScreen.new(args), nav_bar:true, in_detail: true
    else
      open IntroScreen.new(args)
    end
  end

  private

  def read_data
    @done_read_data ||= begin

      @styles = []
      db = SQLite3::Database.new(File.join(App.resources_path, "styles.sqlite"))
      db.execute("SELECT * FROM category ORDER BY id") do |row|
        substyles = []
        db.execute("SELECT * FROM subcategory WHERE category = #{row[:id]} ORDER BY id") do |row2|
          substyles << Style.new(row2)
        end
        row[:substyles] = substyles
        @styles << row
      end

      @table_setup = nil
      update_table_data
    end
  end

end
