SecureHeaders::Configuration.default do |config|

  # All cookies are `Secure` and `HttpOnly`. This means that the browser
  # will not permit JavaScript to read these cookies, and that the
  # browser should not transmit these cookies during repeat visits
  # if that visit uses plaintext HTTP.
  config.cookies = {
    secure: true,
    httponly: true,
  }

  # Strict-Transport-Security (HSTS) specifies how long the user agent
  # should assume the server is still accessible over HTTPS in the future.
  # A duration below 120 days will lower your Qualys SSL Server Test score.
  config.hsts = "max-age=#{356.days}"

  # This site is not allowed to be put inside an iframe or frameset.
  # Other options are ALLOW and SAMEORIGIN.
  config.x_frame_options = "DENY"

  # The user agent should not try to "guess" the content type of resources.
  # For example, it won’t try to evaluate JavaScript files sent as text/plain.
  # Currently only applies to IE. Other browsers never assume types.
  config.x_content_type_options = "nosniff"

  # Do not let IE and Edge attempt to open our web pages as downloaded files.
  config.x_download_options = "noopen"

  # Remote Flash players are not allowed to request anything on our server.
  config.x_permitted_cross_domain_policies = "none"

  # Ask the user agent to enforce it’s cross-site scripting (XSS) filter
  config.x_xss_protection = "1; mode=block"

  # The Referrer-Policy header is turned off.
  # Provide a better value if your application is not just a content site:
  # https://w3c.github.io/webappsec-referrer-policy/#referrer-policies
  config.referrer_policy = SecureHeaders::OPT_OUT

  # The Content-Security-Policy (CSP) header is turned off.
  # We stopped using this feature because it was too cumbersome to maintain with
  # all of the 3rd-party JS and/or GTM code that inevitably gets added to a site.
  config.csp = SecureHeaders::OPT_OUT

end
