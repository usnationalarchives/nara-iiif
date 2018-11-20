require 'csv'

namespace :redirects do
  desc "import redirects"
  task :import => :environment do

    STDOUT.print "CSV URL: "
    url = STDIN.gets.chomp

    csv = CSV.parse(open(url), :headers => true)

    csv.each do |row|
      # assign csv values
      original_path = normalize_path(row["Old"])
      target_uri = normalize_uri(row["New"])

      # persiste Redirect
      redirect = Redirect.find_or_initialize_by(original_path: original_path)
      redirect.target_uri = target_uri

      redirect.save
    end
  end

  def normalize_path(path)
    path = path.squish.chomp("/")
    return URI.encode(URI.parse(path).path)
  end

  def normalize_uri(uri)
    uri = uri.squish.chomp("/")
    return URI.encode(URI.parse(uri).to_s)
  end
end
