module NewsLearner
  class Discoverer
    def self.sites
      %w[
        http://www.cnn.com/
        http://news.google.com/
        http://www.cbsnews.com/
        http://www.reuters.com/
        http://www.bbc.co.uk/news/
        http://news.yahoo.com/
        http://wn.com/
        http://www.msnbc.msn.com/
        http://www.foxnews.com/
        http://www.usatoday.com/
        http://www.cbc.ca/news/
        http://www.time.com/
        http://www.guardiannews.com/
        http://www.nytimes.com/
        http://www.washingtonpost.com/
        http://www.latimes.com/
        http://abcnews.go.com/
      ].uniq
    end
  end
end
