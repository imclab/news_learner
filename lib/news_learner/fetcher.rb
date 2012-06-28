require 'typhoeus'

module NewsLearner
  class Fetcher
    def self.get(url)
      puts "Fetching #{url}"
      response = Typhoeus::Request.get(url,
                                       :follow_location => true,
                                       :max_redirects => 5,
                                       :headers => {
                                         'User-Agent' => "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120427 Firefox/15.0a1"
                                       })
      if response.success? && response.code == 200
        response.body
      else
        puts "Unable to fetch #{url}: #{response.code}"
        nil
      end
    end
  end
end
