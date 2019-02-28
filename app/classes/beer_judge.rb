class BeerJudge

  class << self
    def shows_section?
      BeerJudge.is_installed? || BeerJudge.shows_promo?
    end

    def is_installed?
      beer_judge_url_scheme = NSURL.URLWithString BeerJudge.url_scheme
      UIApplication.sharedApplication.canOpenURL(beer_judge_url_scheme)
    end

    def open(url)
      url = NSURL.URLWithString "#{BeerJudge.url_scheme}//#{url}"
      UIApplication.sharedApplication.openURL url
    end

    def url_scheme
      "beerjudge://"
    end

    def shows_promo?
      return false if BeerJudge.is_installed?
      App::Persistence['hide_judging_tools'].nil? || App::Persistence['hide_judging_tools'] == false
    end
  end

end
