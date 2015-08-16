class JudgingInfoScreen < PM::Screen
  stylesheet JudgingInfoScreenStylesheet
  title I18n.t(:beer_judge_app)
  nav_bar true

  def on_load
    set_nav_bar_button :right, title: I18n.t(:close), action: :close, type: UIBarButtonItemStyleDone
    self.navigationController.setToolbarHidden(false)
    self.toolbarItems = [dont_show_button, flexible_space, purchase_button]

    create_intro
  end

  def on_live_reload
    self.view.subviews.each(&:removeFromSuperview)
    on_load
  end

  def create_intro
    intro = EAIntroView.alloc.initWithFrame(self.view.bounds, andPages:[page_1, page_2, page_3, page_4, page_5, page_6])
    intro.swipeToExit = false
    intro.skipButton = nil
    intro.pageControlY = 54.0
    intro.tapToNext = true
    intro.delegate = self
    intro.showInView(self.view)
  end

  def page_1
    EAIntroPage.page.tap do |pg|
      pg.title = "BeerJudge"
      # pg.titlePositionY = 320
      pg.desc = "A Quick Reference for Judges\nScroll to find out more!"
      pg.descFont = UIFont.fontWithName("Georgia-Italic", size:18)
      # pg.descPositionY = 200;
      pg.titleIconView = "judge_screen_1".uiimage.uiimageview
      pg.titleIconPositionY = 100
    end
  end

  def page_2
    EAIntroPage.page.tap do |pg|
      pg.title = "Quickly identify off flavors and aromas."
      pg.titlePositionY = 120
      pg.titleIconView = "judge_screen_2".uiimage.uiimageview
      pg.titleIconPositionY = 80
    end
  end

  def page_3
    EAIntroPage.page.tap do |pg|
      pg.title = "Access a database of common off flavors."
      pg.titlePositionY = 120
      pg.titleIconView = "judge_screen_3".uiimage.uiimageview
      pg.titleIconPositionY = 80
    end
  end

  def page_4
    EAIntroPage.page.tap do |pg|
      pg.title = "Explore the SRM spectrum\nwith the tap of a finger."
      pg.titlePositionY = 120
      pg.titleIconView = "judge_screen_4".uiimage.uiimageview
      pg.titleIconPositionY = 80
    end
  end

  def page_5
    EAIntroPage.page.tap do |pg|
      pg.title = "Use your camera to estimate a beer's SRM."
      pg.titlePositionY = 120
      pg.titleIconView = "judge_screen_5".uiimage.uiimageview
      pg.titleIconPositionY = 80
    end
  end

  def page_6
    EAIntroPage.page.tap do |pg|
      pg.title = "BeerJudge"
      pg.desc = "Tap To Download Now!"
      pg.descFont = UIFont.fontWithName("Georgia-Italic", size:18)
      pg.titleIconView = "judge_screen_1".uiimage.uiimageview
      pg.titleIconPositionY = 100
    end
  end

  def introDidFinish(introView)
    launch_itunes
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
      :buttons => [I18n.t(:confirm_no), I18n.t(:confirm_yes)],
    }
    alert = BW::UIAlertView.default(options) do |alert|
      if alert.clicked_button.index == 0
        # Whatever.
      else
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
