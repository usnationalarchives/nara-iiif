module ServiceHelper

  # Returns a URL to path_part on your Amazon bucket
  def bucket_url(path_part = "")
    "https://#{ENV.fetch("S3_BUCKET_NAME")}.s3.amazonaws.com/#{path_part}"
  end

  # Returns a URI to path_part on your Fastly CDN
  def fastly_url(path_part = "")
    "https://#{ENV.fetch("FASTLY_CDN_URL")}/#{path_part}"
  end

  # ---------------------------------------------------------------------------
  # THIRD PARTY SERVICE URL CONSTRUCTION
  # ---------------------------------------------------------------------------

  def service_uri(lead, query = {})
    uri = lead << "?" << query.delete_if{|k,v|v.blank?}.to_query.gsub("&","&amp;")
    uri.html_safe
  end

  def twitter_intent_uri(options = {})
    service_uri "https://twitter.com/intent/tweet/", {
      dnt: "true",
      hashtags: options[:hashtags],
      related: options[:related],
      text: options[:text],
      url: options.fetch(:url, current_url),
      via: options[:via],
    }
  end

  def facebook_intent_uri(options = {})
    service_uri "https://www.facebook.com/sharer/sharer.php", {
      u: options.fetch(:u, current_url),
    }
  end

  def pinterest_intent_uri(options = {})
    service_uri "https://pinterest.com/pin/create/button/", {
      description: options[:description],
      media: options[:media],
      url: options.fetch(:url, current_url),
    }
  end

  def google_plus_intent_uri(options = {})
    service_uri "https://plus.google.com/share", {
      url: options.fetch(:url, current_url),
    }
  end

  def linkedin_intent_uri(options = {})
    service_uri "https://www.linkedin.com/shareArticle", {
      mini: "true",
      summary: options[:summary],
      title: options[:title],
      url: options.fetch(:url, current_url),
    }
  end

end
