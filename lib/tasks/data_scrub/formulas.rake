namespace :data_scrub do
  namespace :formulas do
    desc "scrub comments for valid encoding"
    task comments_encoding: :environment do
      # "test test \u2713 test".encode('utf-8') =~ /\p{S}/u
      Formula.non_ascii_comments.each do |formula|
        formula.comments.gsub!(/\p{S}/u) { |char| "[\\u%04x]" % char.unpack('U*')[0] }
        formula.save!
      end
    end
  end
end
