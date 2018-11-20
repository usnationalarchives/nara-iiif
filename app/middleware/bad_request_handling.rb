# Some spiders and other scripts will send Rack/Rails junk requests
# that contain invalid URIs, UTF-8 encodings, or bodies. Catch and return an error 400.
# In the future, one of these will be a ParameterTypeError raised from Rack
# https://github.com/rack/rack/commit/167b6480235ff00ed5f355698bf00ec2f250f72e
# https://github.com/rack/rack/issues/524

class BadRequestHandling

  # Middleware receives an app object from Rack

  def initialize(app)
    @app = app
  end

  # Middleware is called by Rack to run its business and then pass on the call.
  # We simply pass on the call and catch any HTTP400-able exceptions.

  def call(env)

    bad_request_handling_caught_exception = false
    @app.call(env)

  # These exceptions are always 400-able

  rescue ActionController::BadRequest => exception

    bad_request_handling_caught_exception = true
    [400, {"Content-Type" => "text/html"}, [File.read("#{Rails.root}/public/400.html")]]

  # For the rest of the exceptions, we have to check the message to see if its
  # the result of someone feeding bullshit to the Rails application

  rescue ActiveRecord::StatementInvalid => exception

    if exception.message.include?("PG::CharacterNotInRepertoire")
      bad_request_handling_caught_exception = true
      [400, {"Content-Type" => "text/html"}, [File.read("#{Rails.root}/public/400.html")]]
    else
      raise exception
    end

  rescue TypeError => exception

    if exception.message.include?("expected Hash (got String) for param")
      bad_request_handling_caught_exception = true
      [400, {"Content-Type" => "text/html"}, [File.read("#{Rails.root}/public/400.html")]]
    else
      raise exception
    end

  rescue ArgumentError, ActionView::Template::Error => exception

    if exception.message.include?("invalid %-encoding") || exception.message.include?("invalid byte sequence") || exception.message.include?("string contains null byte")
      bad_request_handling_caught_exception = true
      [400, {"Content-Type" => "text/html"}, [File.read("#{Rails.root}/public/400.html")]]
    else
      raise exception
    end

  rescue EOFError => exception

    if exception.message.include?("bad content body")
      bad_request_handling_caught_exception = true
      [400, {"Content-Type" => "text/html"}, [File.read("#{Rails.root}/public/400.html")]]
    else
      raise exception
    end

  # Log exceptions we handled with this middleware

  ensure

    if bad_request_handling_caught_exception
      warning =  "  BadRequestHandling returned HTTP 400 for exception\n"
      warning << "  #{exception.inspect}\n"
      warning << "  "
      env["rack.errors"].write(warning)
    end

  end

end
