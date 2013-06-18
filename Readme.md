# BJCP Style Guide (official)

### A [RubyMotion](http://www.rubymotion.com/) application brought to you by [Mohawk Apps](http://www.mohawkapps.com/).

![App Icon](https://raw.github.com/MohawkApps/BJCPStyleGuide/master/resources/Icon@2x.png)

## How to run the app:

1. You must have a valid license of RubyMotion.
2. Run `bundle`.
3. Run `rake bootstrap` to download the XML data file.
4. Run `rake` to launch the app in the simulator.

## XML Data

For legal reasons, we do not host the XML of all the styles here on github. The BJCP [specifically asks people](http://www.bjcp.org/stylecenter.php) not to post versions of the style guidelines anywhere else.

> Please note that all these materials represent a great deal of hard work on the part of a great many volunteers. You may not use these materials for any commercial purpose without permission. You are NOT authorized to copy and post these guidelines, in any form, either on the web or in print, without specific permission from the BJCP.

There's a simple and automated way to get the file from their website and automatically include it in your project files so that you can successfully build the application. Simply run `rake bootstrap` and it will fetch the XML file and put it in your `/resources` folder.

## Contributing:

1. Fork it.
2. Work on a feature branch.
3. Send me a pull request.

*If you can't contribute but find an issue, please [open an issue](https://github.com/markrickert/BJCPStyleGuide/issues)*
