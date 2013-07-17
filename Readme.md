# BJCP Style Guide (official)

### A [RubyMotion](http://www.rubymotion.com/) application brought to you by [Mohawk Apps](http://www.mohawkapps.com/).

![App Icon](https://raw.github.com/MohawkApps/BJCPStyleGuide/master/resources/Icon@2x.png)

A full copy of the BJCP Style Guidelines always at the ready on your iOS device. Whether you're a beer judge, a homebrewer, or an enthusiast, this free app will come in handy whenever you want a quick lookup of a style description.

## How to run the app from source:

1. You **must** have a valid license of [RubyMotion](http://www.rubymotion.com/).
2. Download the source code.
3. Open a terminal and `cd` into the directory. 
4. Run `bundle` to install dependencies.
5. Run `rake` to launch the app in the simulator.

## Opening a style from another app:

BJCPStyles implements url schemes `bjcpstyle://` and `bjcp://`. You can easily open the BJCPStyles app from Safari to automatically open a style by typing (as an example): `bjcpstyle://3B` which would launch the app and automatically open the *3B: Oktoberfest/Märzen* style page.

### For application developers:

You can check to see if the BJCPStyles app is installed by implementing:

**Objective-C**

```objective-c
- (BOOL)isBJCPStylesInstalled {
  NSURL *bjcpStylesURL = [NSURL URLWithString:@"bjcpstyle:"];
  return  [[UIApplication sharedApplication] canOpenURL:bjcpStylesURL];
}
```

**RubyMotion**

```ruby
def bjcpstyles_installed?
  bjcpstyles_url = NSURL.URLWithString "bjcpstyle:"
  UIApplication.sharedApplication.canOpenURL bjcpstyles_url
end
```

Then to actually call the app to open and go to a style:

**Objective-C**

```objective-c
- (void)openBJCPStyle(style) {
  NSURL *bjcpStylesURL = [NSURL URLWithString:[NString stringWithFormat:@"bjcpstyle://%@", style]];
  [[UIApplication sharedApplication] openURL:bjcpStylesURL];
}
```

**RubyMotion**

```ruby
def open_bjcpstyle(style)
  url = NSURL.URLWithString "bjcpstyle://#{style}"
  UIApplication.sharedApplication.openURL url
end
```


## Contributing:

1. Fork it.
2. Work on a feature branch.
3. Send me a pull request.

*If you can't contribute but find an issue, please [open an issue](https://github.com/markrickert/BJCPStyleGuide/issues)*

## Internationalization:

I'd love to have the style guidelines translated into other languages. If you'd like to contribute a translation, check out the `resources/db/en_US` folder for the official SQLite database of styles. You can then copy that db into your own internationalized folder and make translations for the guidelines.
