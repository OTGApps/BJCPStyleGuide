describe "MainScreen functionality" do
  tests MainScreen

  # Override controller to properly instantiate
  def controller
    rotate_device to: :portrait, button: :bottom
    @screen ||= MainScreen.new(nav_bar: true)
    @screen.will_appear
    @screen.navigation_controller
  end

  after do
    @screen = nil
  end

  it "should have a navigation bar" do
    @screen.navigationController.should.be.kind_of(UINavigationController)
  end

  it "should have lots of sections" do
  	@screen.table_data.count.should > 10
  end

  it "should have Styles as cell data" do
  	@screen.table_data[5][:cells].each do |cell|
  		cell[:arguments][:style].class.should == Style
  	end
	end
end
