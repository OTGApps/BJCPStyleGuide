describe "Core Ruby Extensions" do

	it "should drop elements from the end of the array" do
		a = %w{1, 2, 3, 4, 5, 6, 7}
		a.drop(1).should == %w{2, 3, 4, 5, 6, 7}
		a.drop(2).should == %w{3, 4, 5, 6, 7}
		a.drop(3).should == %w{4, 5, 6, 7}
	end

	it "should title case words" do
		"the quick brown dog jumped over the lazy fox".titlecase.should == "The Quick Brown Dog Jumped Over The Lazy Fox"
		"THIS IS ALL CAPS".titlecase.should == "This Is All Caps"
	end

	it "should return letters as integers" do
		"a".as_integer.should == 1
		"A".as_integer.should == 1
		"z".as_integer.should == 26
		"Z".as_integer.should == 26
		"m".as_integer.should == 12
	end

	it "should return integers as letters" do
		1.as_letter.should == "A"
		10.as_letter.should == "J"
		26.as_letter.should == "Z"
	end

end
