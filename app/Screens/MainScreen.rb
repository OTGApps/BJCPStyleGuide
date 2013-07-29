class MainScreen < ProMotion::TableScreen
  title "2008 BJCP Styles".__
  searchable :placeholder => "Search Styles".__
  attr_accessor :selected_cell

  def on_load
    SVProgressHUD.showWithStatus("Loading".__, maskType:SVProgressHUDMaskTypeBlack)

    set_attributes self.view, { backgroundColor: UIColor.whiteColor }

    unless Device.ipad?
      set_nav_bar_right_button UIImage.imageNamed("info.png"), action: :open_about_screen
    end

    backBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Back".__, style:UIBarButtonItemStyleBordered, target:nil, action:nil)
    self.navigationItem.backBarButtonItem = backBarButtonItem

    @reload_observer = App.notification_center.observe "ReloadNotification" do |notification|
      @table_setup = nil
      update_table_data
    end

    # Check to see if we should go directly into a style when the app is already loaded.
    @style_observer ||= App.notification_center.observe "GoDirectlyToStyle" do |notification|
      App.delegate.jump_to_style = notification.object[:object]
    end

    read_data
  end

  def auto_open_style
    return if App.delegate.jump_to_style.nil? || @styles.nil?

    style = App.delegate.jump_to_style
    cat = (style[0..-2].to_i) - 1
    subcat = style[-1]
    subcat_int = subcat.as_integer - 1

    # Find it in the array
    requested_style = @styles[cat][:substyles][subcat_int]
    App.delegate.jump_to_style = nil

    if requested_style.nil?
      App.alert "Invalid style requested:".__ + " \"#{style}\"."
    else
      # Scroll to the right position on the device.
      cat += 1 # For the intros section
      cat += 1 if BeerJudge.is_installed? || shows_beer_judging_section?

      # Wait for a bit before selecting the table cell since we don't know when the
      # tableview actually updates.
      if Device.ipad?
        count = 0
        timer = EM.add_periodic_timer 0.2 do
          count = count + 1
          (count < 10) || EM.cancel_timer(timer)

          if table_view.numberOfSections > 0
            EM.cancel_timer(timer)
            indexPath = NSIndexPath.indexPathForRow(subcat_int, inSection:cat)
            table_view.scrollToRowAtIndexPath(indexPath, atScrollPosition:UITableViewScrollPositionMiddle, animated:false)
            table_view.selectRowAtIndexPath(indexPath, animated:false, scrollPosition:UITableViewScrollPositionNone)
          end
        end
      end

      # TODO: Pop back to the root view controller
      # pop_to_root animated: false

      open_style style: requested_style
    end
  end

  def on_appear
    self.navigationController.setToolbarHidden(true, animated:true) unless searching?

    # Re-call on_appear when the application resumes from the background state since it's not called automatically.
    @on_appear_observer ||= App.notification_center.observe UIApplicationDidBecomeActiveNotification do |notification|
      on_appear
    end

    auto_open_style
  end

  def table_data
    return [] if @styles.nil?
    @table_setup ||= begin
      s = []
      s << judging_section_links if BeerJudge.is_installed?
      s << judging_section_preview if shows_beer_judging_section?
      s << {
        title: "Introductions".__,
        cells: [
          intro_cell("Beer Introduction"),
          intro_cell("Mead Introduction"),
          intro_cell("Cider Introduction")
        ]
      }

      @styles.each do |section|
        section_placeholder = {
          title: "#{section[:id]}: #{section[:name]}",
          cells: build_subcategories(section)
        }
        section_placeholder[:title] << " (#{section[:transname]})" unless section[:transname].nil? || section[:transname] == ""
        s << section_placeholder
      end
      s
    end
    auto_open_style
    @table_setup
  end

  def next
    return if self.selected_cell.nil?

    section = self.selected_cell.section
    row = self.selected_cell.row

    if !table_data[section][:cells][row + 1].nil?
      scroll_to NSIndexPath.indexPathForRow(row + 1, inSection: section)
    elsif section + 1 < table_data.count
      scroll_to NSIndexPath.indexPathForRow(0, inSection: section + 1)
    end
  end

  def previous
    return if self.selected_cell.nil?

    section = self.selected_cell.section
    row = self.selected_cell.row

    if row != 0
      scroll_to NSIndexPath.indexPathForRow(row - 1, inSection: section)
    elsif defined? table_data[section - 1]
      scroll_to NSIndexPath.indexPathForRow(table_data[section - 1][:cells].count - 1, inSection: section - 1)
    end
  end

  def scroll_to(ip)
    table_view.selectRowAtIndexPath(ip, animated:true, scrollPosition:UITableViewScrollPositionMiddle)
    tableView(table_view, didSelectRowAtIndexPath:ip)
  end

  def intro_cell(name)
    {
      title: name,
      searchable: false,
      cell_identifier: "IntroductionCell",
      action: :open_intro_screen,
      arguments: {:file => Internationalization.resources_path("#{name}.html"), :title => name}
    }
  end

  def judging_section_links
    # Show the judging Tools
    {
      title: "Judging Tools".__,
      cells: judging_cells
    }
  end

  def judging_section_preview
    # Show the intro screen
    {
      title: "Judging Tools".__,
      cells: [{
        title: "Check Out the App!".__,
        cell_identifier: "JudgingCell",
        searchable: false,
        action: :open_judging_info_screen,
        image: {
          image:"judge.png",
          radius: 8
        }
      }]
    }
  end

  def shows_beer_judging_section?
    return false if BeerJudge.is_installed? || Device.ios_version.to_i < 6.0
    App::Persistence['hide_judging_tools'].nil? ||  App::Persistence['hide_judging_tools'] == false
  end

  def judging_cells
    c = []
    %w(Flavor\ Wheel SRM\ Spectrum SRM\ Analyzer).each do |tool|
      downcased_tool = tool.downcase.tr(" ", "_")
      c << {
        title: tool,
        searchable: false,
        cell_identifier: "JudgingCell",
        action: :open_judging_tool,
        arguments: {url: downcased_tool},
        image: "judge_#{downcased_tool}.png"
      }
    end
    c
  end

  def build_subcategories(section)
    c = []
    section[:substyles].each do |subcat|
      c <<{
        title: subcat.title,
        subtitle: subcat.transname,
        cell_style: UITableViewCellStyleSubtitle,
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
    drop = shows_beer_judging_section? ? 2 : 2
    droped_intro = shows_beer_judging_section? ? ["{search}", "J", "?"] : ["{search}", "?"]

    droped_intro + table_data.drop( drop ).collect do |section|
      section[:title].split(" ").first[0..-2]
    end
  end

  def open_style(args={})
    if Device.ipad?
      open DetailScreen.new(args), nav_bar:true, in_detail: true
    else
      open DetailScreen.new(args)
    end
  end

  def open_about_screen(args={})
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

  def open_judging_info_screen
    open_modal JudgingInfoScreen.new, nav_bar: true, presentation_style: UIModalPresentationFormSheet
  end

  def open_judging_tool(args={})
    BeerJudge.open(args[:url])
  end

  private

  def read_data

    Dispatch::Queue.concurrent.async do
      styles = []

      db = SQLite3::Database.new Internationalization.full_path("styles.sqlite")
      db.execute("SELECT * FROM category ORDER BY id") do |row|
        substyles = []
        db.execute("SELECT * FROM subcategory WHERE category = #{row[:id]} ORDER BY id") do |row2|
          substyles << Style.new(row2)
        end
        row[:substyles] = substyles
        styles << row
      end

      Dispatch::Queue.main.sync do
        @styles = styles
        @table_setup = nil
        update_table_data
        SVProgressHUD.dismiss

        # Check to see if we should go directly into a style when the app is not in memory.
        auto_open_style
      end

    end
  end

  # Override form Promotion
  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    if Device.ipad?
      table_view.deselectRowAtIndexPath(self.selected_cell, animated: true) unless self.selected_cell.nil?
      self.selected_cell = index_path
    else
      table_view.deselectRowAtIndexPath(index_path, animated: true)
    end

    data_cell = @promotion_table_data.cell(index_path: index_path)

    data_cell[:arguments] ||= {}
    data_cell[:arguments][:cell] = data_cell if data_cell[:arguments].is_a?(Hash) # TODO: Should we really do this?

    trigger_action(data_cell[:action], data_cell[:arguments]) if data_cell[:action]
  end

end
