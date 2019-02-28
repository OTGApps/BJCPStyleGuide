class MainScreen < ProMotion::TableScreen
  stylesheet MainScreenStylesheet
  searchable placeholder: I18n.t(:search_styles)
  attr_accessor :selected_cell, :search_string

  def on_load
    self.title = Version.title

    set_nav_bar_button :back, title: '', style: :plain, action: :back
    set_nav_bar_button :right, image: UIImage.imageNamed('info'), action: :open_about_screen
    set_nav_bar_button :left, image: UIImage.imageNamed('swap'), action: :toggle_styles

    @reload_observer = App.notification_center.observe "ReloadNotification" do |notification|
      @table_setup = nil
      update_table_data
    end

    # Check to see if we should go directly into a style when the app is already loaded.
    @style_observer ||= App.notification_center.observe "GoDirectlyToStyle" do |notification|
      App.delegate.jump_to_style = notification.object[:object]
    end
  end

  # def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
  #   self.searchDisplayController.setActive(false, animated:false)
  # end

  def will_appear
    read_data if @styles.nil?
  end

  def toggle_styles
    Version.toggle

    if device.ipad?
      open IntroScreen.new({
        file: Internationalization.file_url("DefaultScreen.html"),
        title: "Welcome"}), in_detail: true
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
      rmq.app.alert I18n.t(:invalid_style) + " \"#{style}\"."
    else
      # Scroll to the right position on the device.
      cat += 1 if BeerJudge.shows_section?
      cat += 1 # For the intros section

      # Wait for a bit before selecting the table cell since we don't know when the
      # tableview actually updates.
      if device.ipad?
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

      open_style({style: requested_style}, nil)
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
    return [{cells:[{title: "Loading..."}]}] if @styles.nil?
    @table_setup ||= begin
      s = []
      s << judging_section_links if BeerJudge.is_installed?
      s << judging_section_promo if BeerJudge.shows_promo?
      s << {
        title: I18n.t(:introductions),
        cells: introduction_cells
      }

      @styles.each do |section|
        section_placeholder = {
          title: section_title(section),
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

  def section_title(section)
    if section[:type].as_type == 'P'
      # Don't auto-label provisional styles
      return section[:name]
    end

    s = "#{section[:id]}: #{section[:name]}"
    s.insert(0, section[:type].as_type) if Version.version_2015? && section[:type] > 1
    s
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

  def introduction_cells
    cells = []
    cells << intro_cell("Introduction") if Version.version_2015?
    cells << intro_cell("Beer Introduction")
    cells << intro_cell("Specialty Beer Introduction") if Version.version_2015?
    cells << intro_cell("Mead Introduction")
    cells << intro_cell("Cider Introduction")
    cells
  end

  def intro_cell(name)
    {
      title: name,
      searchable: false,
      cell_identifier: "IntroductionCell",
      accessory_type: :disclosure_indicator,
      action: :open_intro_screen,
      arguments: {
        file: Internationalization.file_url("#{name}.html"),
        title: name,
        nav_bar: true,
      }
    }
  end

  def judging_section_links
    # Show the judging Tools
    {
      title: I18n.t(:judging_tools),
      cells: judging_cells
    }
  end

  def judging_section_promo
    # Show the intro screen
    {
      title: I18n.t(:judging_tools),
      cells: [{
        title: I18n.t(:check_out_app),
        cell_identifier: "JudgingCell",
        accessory_type: :disclosure_indicator,
        searchable: false,
        action: :open_judging_info_screen,
        image: {
          image:"judge.png",
          radius: 8
        }
      }]
    }
  end

  def judging_cells
    c = []
    %w(Flavor\ Wheel SRM\ Spectrum SRM\ Analyzer).each do |tool|
      downcased_tool = tool.downcase.tr(" ", "_")
      c << {
        title: tool,
        searchable: false,
        accessory_type: :disclosure_indicator,
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
        accessory_type: :disclosure_indicator,
        subtitle: subcat.transname,
        search_text: subcat.search_text,
        keep_selection: device.ipad? ? true : false,
        cell_identifier: "SubcategoryCell",
        action: :open_style,
        arguments: {
          style: subcat,
          nav_bar: true
        }
      }
    end
    c
  end

  def table_data_index
    return if table_data.count < 1
    # Get the style number of the section
    drop_number = BeerJudge.shows_section? ? 2 : 1
    droped_intro = BeerJudge.shows_section? ? ["{search}", "J", "?"] : ["{search}", "?"]

    droped_intro + table_data.drop( drop_number ).collect do |section|
      if section[:title].include?(":")
        section[:title].split(" ").first[0..-2]
      else
        section[:title][0]
      end
    end
  end

  def open_style(args, index_path)
    self.selected_cell = index_path

    open_args = args.merge({nav_bar: true})
    open_args = args.merge({search_string: search_string}) if searching?
    if device.ipad?
      app.hide_keyboard
      open(DetailScreen.new(open_args), in_detail: true)
    else
      open(DetailScreen.new(open_args))
    end
  end

  def open_about_screen
    open_modal AboutScreen.new(nav_bar: true, external_links: true),
      presentation_style: UIModalPresentationPageSheet
  end

  def open_intro_screen(args)
    if device.ipad?
      open IntroScreen.new(args), in_detail: true
    else
      open IntroScreen.new(args)
    end
  end

  def open_judging_info_screen
    open_modal JudgingInfoScreen.new(nav_bar: true), presentation_style: UIModalPresentationPageSheet
  end

  def open_judging_tool(args={})
    BeerJudge.open(args[:url])
  end

  private

  def read_data
    self.title = Version.title
    Motion::Blitz.show(I18n.t(:loading), :black)

    Dispatch::Queue.concurrent.async do
      styles = []

      db = SQLite3::Database.new Internationalization.full_path("styles.sqlite")

      if Version.version_2015?
        query = "SELECT * FROM category ORDER BY type, id"
      else
        query = "SELECT * FROM category ORDER BY id"
      end

      db.execute(query) do |row|
        if Version.version_2015?
          query = "SELECT * FROM subcategory WHERE category = #{row[:internal_id]} ORDER BY id"
        else
          query = "SELECT * FROM subcategory WHERE category = #{row[:id]} ORDER BY id"
        end

        substyles = []
        db.execute(query) do |row2|
          if Version.version_2015?
            row2[:category] = row[:id]
            row2[:type] = row[:type].as_type
          end
          substyles << Style.new(row2)
        end
        row[:substyles] = substyles
        styles << row
      end

      Dispatch::Queue.main.sync do
        @styles = styles
        @table_setup = nil
        update_table_data
        Motion::Blitz.dismiss

        # Check to see if we should go directly into a style when the app is not in memory.
        auto_open_style

        # Check to see if we should ask to use 2008 or 2015 styles.
        rmq.app.alert({
          title: I18n.t(:picker_title),
          message: I18n.t(:picker_message),
          actions: ['2008', '2015']
        }) do |action_button|
          mp action_button
          if action_button == '2008'
            Version.set('2008')
            read_data
          else
            Version.set('2015')
          end
        end unless Version.set?
      end

    end
  end
end
