describe "MainScreen functionality" do
  tests MainScreen

  # Override controller to properly instantiate
  def controller
    rotate_device to: :portrait, button: :bottom
    @screen ||= MainScreen.new
    @screen.will_appear
    @screen.navigation_controller
  end

  after do
    @screen = nil
  end

  it "should have a navigation bar" do
    wait 0.5 do
      @screen.navigationController.should.be.kind_of(UINavigationController)
    end
  end

  it "should have lots of sections" do
    wait 0.5 do
    	@screen.table_data.count.should > 10
    end
  end

  it "should have Styles as cell data" do
    wait 0.5 do
    	@screen.table_data[5][:cells].each do |cell|
    		cell[:arguments][:style].class.should == Style
    	end
    end
	end
end
