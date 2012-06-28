require_relative 'fetcher'
require_relative 'discoverer'
require 'pp'

module NewsLearner
  class Clusterer
    NGRAM_SIZE = 5
    FILE_NAME = "data/data.marshal"
    attr_accessor :data

    def initialize
      load
    end

    def load(filename = FILE_NAME)
      @data = File.exists?(filename) ? Marshal.load(File.read(filename)) : {}
    end

    def save(filename = FILE_NAME, output_data = data)
      system "mkdir -p #{File.dirname(filename)}"
      File.open(filename, "wb") do |file|
        file.print Marshal.dump(output_data)
      end
    end

    def time_stamp
      Time.now.utc.strftime("%Y-%m-%d_%H-%M-%S")
    end

    def save_snapshot_data(ngrams_for_site)
      save "snapshots/daily_snapshot_#{time_stamp}.marshal", ngrams_for_site
    end

    def save_html(site, html)
      path = "sites/#{site.gsub(/^https?:\/\/(www\.)?|\/$/, '').gsub(/[^a-zA-Z0-9_-]/, '-').gsub(/-{2,}/, '-')}"
      system "mkdir -p #{path}"
      File.open("#{path}/#{time_stamp}.html", "wb") do |file|
        file.print html
      end
    end

    def cluster
      tf = {}
      Discoverer.sites.each do |site|
        html = Fetcher.get(site)
        next unless html

        save_html site, html

        tokens = tokenize(html)
        ngrams_for_site = 1.upto(NGRAM_SIZE).map { |ngram_size|
          tokens.each_cons(ngram_size).map { |group| group.join(" ") }
        }.flatten.uniq
        ngrams_for_site.each do |ngram|
          tf[ngram] ||= 0
          tf[ngram] += 1
        end
      end

      save_snapshot_data tf

      data[:counts] ||= {}
      tf_on_atleast_three_pages = tf.to_a.sort {|a, b| b.last <=> a.last }.select { |ngram, count| count > 3 }
      tf_on_atleast_three_pages.each do |ngram, count|
        data[:counts][ngram] ||= 0
        data[:counts][ngram] += 1
      end

      data[:cardinality] ||= 0
      data[:cardinality] += 1

      pp tf_on_atleast_three_pages.map { |ngram, count|
        [ngram, count * idf(ngram)]
      }.sort {|a, b| a.last <=> b.last }[0..100]
    end

    def idf(term)
      Math.log(data[:cardinality] / (1 + data[:counts][term]).to_f)
    end

    def tokenize(str)
      str.gsub(/[^a-zA-Z0-9_-]/, ' ').squeeze(" ").strip.split(" ")
    end
  end
end
