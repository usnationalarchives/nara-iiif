class SitemapController < ApplicationController

  def sitemap
    @urls = sitemap_urls
    expires_in 5.minutes
    fresh_when etag: global_etag_key, public: true
  end

  private

  def sitemap_urls

    urls = [
      root_url,
    ]

    # Provide logic here that appends any relevant URLs to the sitemap list

    urls

  end

end
