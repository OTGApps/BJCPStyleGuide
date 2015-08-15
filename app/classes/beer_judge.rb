class BeerJudge

  class << self
    def is_installed?
      beer_judge_url_scheme = NSURL.URLWithString BeerJudge.url_scheme
      UIApplication.sharedApplication.canOpenURL(beer_judge_url_scheme)
    end

    def open(url)
      url = NSURL.URLWithString "#{BeerJudge.url_scheme}//#{url}"
      UIApplication.sharedApplication.openURL url
    end

    def url_scheme
      "beerjudge:"
    end
  end

end
