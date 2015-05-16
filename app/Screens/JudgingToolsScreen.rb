class JudgingInfoScreen < PM::Screen
  PAGES = %w(judge_screen_1 judge_screen_2 judge_screen_3 judge_screen_4 judge_screen_5)
  PAGE_INSET = 20

  title I18n.t(:beer_judge_app)

  def will_appear
    @view_set_up ||= begin
      set_attributes self.view, {
        background_color: UIColor.colorWithPatternImage(UIImage.imageNamed("linnen.png"))
      }

      self.edgesForExtendedLayout = UIRectEdgeNone if Device.ios_version.to_f >= 7.0

      @gallery = add SwipeView.new, {
        top: 0,
        left: 0,
        width: view.frame.size.width,
        height: view.frame.size.height - (Device.ios_version.to_f >= 7.0 ? 140 : 84),
        dataSource: self,
        delegate: self,
        alignment: 1, # SwipeViewAlignment.SwipeViewAlignmentCenter
        pagingEnabled: true,
        itemsPerPage: 1
      }
      @gallery.itemSize = @gallery.frame.size

      @paging = add UIPageControl.new, {
        number_of_pages: PAGES.count
      }

      set_nav_bar_right_button I18n.t(:close), action: :close, type: UIBarButtonItemStyleDone
      self.navigationController.setToolbarHidden(false)
      self.toolbarItems = [dont_show_button, flexible_space, purchase_button]
    end
    Flurry.logEvent "JudgingToolsViewed" unless Device.simulator?
  end

  def on_appear
    @paging.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 10)
  end

  def numberOfItemsInSwipeView swipeView
    PAGES.count
  end

  def swipeView swipeView, viewForItemAtIndex: index, reusingView: view
    unless view
      view = UIImageView.alloc.initWithFrame CGRectInset(@gallery.frame, 0, PAGE_INSET)
      view.contentMode = UIViewContentModeScaleAspectFit
      Shadow.addTo view
    end
    view.image = UIImage.imageNamed PAGES[index]
    view
  end

  def swipeViewCurrentItemIndexDidChange swipeView
    @paging.currentPage = swipeView.currentPage
    Flurry.logEvent "JudgingToolsSwiped" unless Device.simulator?
  end

  def swipeViewItemSize swipeView
    self.view.frame.size
  end

  def swipeView(swipeView, didSelectItemAtIndex:index)
    launch_itunes if index == numberOfItemsInSwipeView(swipeView)-1
  end

  def dont_show_button
    UIBarButtonItem.alloc.initWithTitle(I18n.t(:dont_show_again), style: UIBarButtonItemStyleBordered, target: self, action: :remove_feature)
  end

  def purchase_button
    UIBarButtonItem.alloc.initWithTitle(I18n.t(:go_to_app_store), style: UIBarButtonItemStyleBordered, target: self, action: :launch_itunes)
  end

  def flexible_space
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
  end

  def remove_feature
    options = {
      :title   => I18n.t(:are_you_sure),
      :message => I18n.t(:permanently_hide),
      :buttons => [I18n.t(:no), I18n.t(:yes)],
    }
    alert = BW::UIAlertView.default(options) do |alert|
      if alert.clicked_button.index == 0
        # Whatever.
        Flurry.logEvent "JudgingToolsHidAbout" unless Device.simulator?
      else
        Flurry.logEvent "JudgingToolsHid" unless Device.simulator?
        App::Persistence['hide_judging_tools'] = true
        App.notification_center.post "ReloadNotification"
        App.alert(I18n.t(:removed_from_app)) do |a|
          close
        end
      end
    end

    alert.show
  end

  def launch_itunes
    Flurry.logEvent "JudgingToolsLaunchediTunes" unless Device.simulator?
    close
    App.open_url "https://itunes.apple.com/us/app/beer-judge/id666120064?mt=8&uo=4&at=10l4yY&ct=bjcp_app"
  end

  def shouldAutorotate
    false
  end

  def supportedInterfaceOrientations
    if Device.iphone?
      UIInterfaceOrientationMaskPortrait
    else
      UIInterfaceOrientationMaskAll
    end
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    if Device.iphone?
      interfaceOrientation == UIInterfaceOrientationPortrait
    else
      true
    end
  end

  def preferredInterfaceOrientationForPresentation
    if Device.iphone?
      UIInterfaceOrientationPortrait
    else
      UIInterfaceOrientationMaskAll
    end
  end



end
