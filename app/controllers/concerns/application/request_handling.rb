# --------------------------------------------------------------------------------
# Application::RequestHandling provides methods for redirects, rendering errors
# and handling malformed requests
# --------------------------------------------------------------------------------
# This concern is included in the ApplicationController and doesnt need to be
# included on individual resource controllers

module Application::RequestHandling

  extend ActiveSupport::Concern

  included do

    before_action :production_redirect if Rails.env.production?
    before_action :add_standards_support_header

    # ---------------------------------------------------------------------------
    # SYSTEM-LEVEL RENDERING/REDIRECTS
    # These functions let you nicely do code like
    # @projects = Project.find_by_id(params[:id]) or return redirect_or_http404
    # ---------------------------------------------------------------------------

    def redirect_or_http404
      @requested_path = request.path.split(".").first
      puts "Trying redirect for #{@requested_path}"
      if @redirect = Redirect.find_by_original_path(@requested_path)
        puts "Redirect found #{@redirect.id}:"
        return redirect_to @redirect.actualized_redirect_target(request.query_parameters.to_query), status:301
      else
        if Rails.application.config.consider_all_requests_local
          raise ActionController::RoutingError.new "No route matches [#{request.request_method}] #{request.path}"
        else
          return http404
        end
      end
    end

    def http400 # Bad Request
      render file:"#{Rails.root}/public/400.html", status:400, formats:[:html], layout:false
    end

    def http403 # Forbidden
      render file:"#{Rails.root}/public/403.html", status:403, formats:[:html], layout:false
    end

    def http404 # Not Found
      render file:"#{Rails.root}/public/404.html", status:404, formats:[:html], layout:false
    end

    def http406 # Not Acceptable
      render file:"#{Rails.root}/public/406.html", status:406, formats:[:html], layout:false
    end

    def http422 # Unprocessible Entity
      render file:"#{Rails.root}/public/422.html", status:422, formats:[:html], layout:false
    end

    def http500 # Internal Server Error
      render file:"#{Rails.root}/public/500.html", status:500, formats:[:html], layout:false
    end

    def http503 # Service Unavailable
      render file:"#{Rails.root}/public/503.html", status:503, formats:[:html], layout:false
    end

    def http504 # Gateway Timeout
      render file:"#{Rails.root}/public/504.html", status:504, formats:[:html], layout:false
    end

    protected

    # Force visitors to use the canonical domain
    def production_redirect
      unless "#{request.protocol}#{request.host_with_port}" == ENV.fetch("EXPECTED_HOSTNAME")
        return redirect_to "#{ENV.fetch("EXPECTED_HOSTNAME")}#{request.fullpath}", status:301
      end
    end

    # Add “X-UA-Compatible” header to force old IE to render in the highest mode available.
    # On rare occasions, IT departments will set IE to render as the previous version
    # (e.g. IE 9 will be set to render in IE 8 mode). This header should fix that.
    #
    # We should consider removing this header once we no longer support IE 10-.
    # https://stackoverflow.com/a/26348511/673457
    # https://stackoverflow.com/a/6771584/673457
    def add_standards_support_header
      response.headers["X-UA-Compatible"] = "IE=edge"
    end

    # ---------------------------------------------------------------------------
    # RESCUE SYSTEMS
    # Handle invalid or malformed junk thrown at the Rails application
    # ---------------------------------------------------------------------------

    # Whenever bad browsers and clients request formats that Rails does not
    # expect, Rails raises an ActionView::MissingTemplate or
    # ActionController::UnknownFormat, but we really want to return an
    # HTTP 406 or HTTP 400 to these kinds of requests instead
    unless Rails.application.config.consider_all_requests_local
      rescue_from ActionView::MissingTemplate, ActionController::UnknownFormat do
        http406
      end
    end

  end

end
