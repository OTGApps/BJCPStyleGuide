class JudgingInfoScreen < PM::Screen
  PAGES = %w(judge_screen_1 judge_screen_2 judge_screen_3 judge_screen_4 judge_screen_5)
  PAGE_INSET = 20

  title "BeerJudge App"._

  def will_appear
    @view_set_up ||= begin
      set_attributes self.view, {
        background_color: UIColor.colorWithPatternImage(UIImage.imageNamed("linnen.png"))
      }

      @gallery = add SwipeView.new, {
        top: 0,
        left: 0,
        width: view.frame.size.width,
        height: view.frame.size.height - 20 - 44,
        dataSource: self,
        delegate: self,
        alignment: 1, # SwipeViewAlignment.SwipeViewAlignmentCenter
        pagingEnabled: true,
        itemsPerPage: 1,
      }
      @gallery.itemSize = @gallery.frame.size

      @paging = add UIPageControl.new, {
        top: self.view.frame.size.height - 20 - 44,
        left: 0,
        height: 10,
        width:self.view.frame.size.width,
        numberOfPages: PAGES.count
      }

      set_nav_bar_right_button "Close"._, action: :close, type: UIBarButtonItemStyleDone
      self.navigationController.setToolbarHidden(false)
      self.toolbarItems = [dont_show_button, flexible_space, purchase_button]
    end
    Flurry.logEvent "JudgingToolsViewed" unless Device.simulator?
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
    UIBarButtonItem.alloc.initWithTitle("Don't Show Again"._, style: UIBarButtonItemStyleBordered, target: self, action: :remove_feature)
  end

  def purchase_button
    UIBarButtonItem.alloc.initWithTitle("Go to the App Store"._, style: UIBarButtonItemStyleBordered, target: self, action: :launch_itunes)
  end

  def flexible_space
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
  end

  def remove_feature
    options = {
      :title   => "Are you sure?"._,
      :message => "permanently hide?"._,
      :buttons => ["No"._, "Yes"._],
    }
    alert = BW::UIAlertView.default(options) do |alert|
      if alert.clicked_button.index == 0
        # Whatever.
        Flurry.logEvent "JudgingToolsHidAbout" unless Device.simulator?
      else
        Flurry.logEvent "JudgingToolsHid" unless Device.simulator?
        App::Persistence['hide_judging_tools'] = true
        App.notification_center.post "ReloadNotification"
        App.alert("removed from the app"._) do |a|
          close
        end
      end
    end

    alert.show
  end

  def launch_itunes
    Flurry.logEvent "JudgingToolsLaunchediTunes" unless Device.simulator?
    app_name = "beerjudge"
    id = "666120064"
    url_string = "http://click.linksynergy.com/fs-bin/stat?id=**BiWowje1A&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Fapp%252F#{app_name}%252Fid#{id}%253Fmt%253D8%2526uo%253D4%2526partnerId%253D30"
    close
    App.open_url url_string
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

end
