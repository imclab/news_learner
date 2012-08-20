require 'pp'

def tokenize(str)
  str.gsub(/[^a-zA-Z0-9_-]/, ' ').downcase.squeeze(" ").strip.split(" ")
end

def idf(term, data)
  Math.log(data[:cardinality] / (1 + data[:counts][term]).to_f)
end

NGRAM_SIZE = 7

data = { :counts => {}, :cardinality => 0 }

sites = {}
lengths = {}

Dir["sites/*"].each do |dir|
  sites[dir] = Dir["#{dir}/*.html"].sort
  lengths[sites[dir].length] ||= 0
  lengths[sites[dir].length] += 1
end

most_common_number_of_records = lengths.to_a.sort {|a, b| b.last <=> a.last }.first.first

puts "Most common length: #{most_common_number_of_records}"

most_common_number_of_records.times do |index|
  data[:cardinality] += 1
  tf = {}

  sites.each do |directory, files|
    if path = File.read(files[index])
      tokens = tokenize(path)

      ngrams_for_site = 1.upto(NGRAM_SIZE).map { |ngram_size|
        tokens.each_cons(ngram_size).map { |group| group.join(" ") }.reject {|t| t =~ /^[\d ]+$/ }
      }.flatten.uniq

      ngrams_for_site.each do |ngram|
        tf[ngram] ||= 0
        tf[ngram] += 1
      end
    end
  end

  tf_on_atleast_three_pages = tf.to_a.sort {|a, b| b.last <=> a.last }.select { |ngram, count| count > 3 }
  tf_on_atleast_three_pages.each do |ngram, count|
    # Increment ngram counts for all ngrams on at least 3 sites.
    data[:counts][ngram] ||= 0
    data[:counts][ngram] += 1
  end

  pp tf_on_atleast_three_pages.map { |ngram, count|
    [ngram, count * idf(ngram, data)]
  }.sort {|a, b| b.last <=> a.last }.reject { |ngram, count| ngram.scan(/ /).length < 3 }[0..10]

  puts
  puts
end
