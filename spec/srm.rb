describe "SRM class unit tests" do

	it "should return a color for a srm" do
		(1..40).to_a.each do |srm|
			SRM.color(srm.to_s).class.should == UIDeviceRGBColor
		end
	end

	it "should return a CGColor for a srm" do
		(1..40).to_a.each do |srm|
			SRM.cgcolor(srm.to_s).class.should == UIColor.whiteColor.CGColor.class
		end
	end

	it "should return all SRM steps" do
		SRM.steps.count.should == 40
	end

	it "should return the full spectrum" do
		SRM.spectrum.each do |srm|
			srm.class.should == UIColor.whiteColor.CGColor.class
		end
	end

	it "should produce an image from a srm color" do
		image = SRM.imageWithSRM(1, andSize:CGSizeMake(10.0, 10.0))
		image.class.should == UIImage
	end

end
