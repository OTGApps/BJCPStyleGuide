class JudgingInfoScreen < PM::Screen
  PAGES = %w(judge_screen_1 judge_screen_2 judge_screen_3)
  PAGE_INSET = 20

  title "BeerJudge App"

  def will_appear
    set_attributes self.view, {
      background_color: UIColor.colorWithPatternImage(UIImage.imageNamed("linnen.png"))
    }

    @gallery = add SwipeView.alloc.initWithFrame([[0,0],[view.frame.size.width, view.frame.size.height - 20]]), {
      dataSource: self,
      delegate: self,
      alignment: 1, # SwipeViewAlignment.SwipeViewAlignmentCenter
      pagingEnabled: true,
      itemsPerPage: 1,
    }
    @gallery.itemSize = @gallery.frame.size

    @paging = add UIPageControl.new, {
      top: self.view.frame.size.height - 20,
      left: 0,
      height: 10,
      width:self.view.frame.size.width,
      numberOfPages: PAGES.count
    }

    set_nav_bar_right_button "Close", action: :close_modal, type: UIBarButtonItemStyleDone
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
  end

  def swipeViewItemSize swipeView
    self.view.frame.size
  end

  def close_modal
    self.navigationController.dismissModalViewControllerAnimated(true)
  end

end
