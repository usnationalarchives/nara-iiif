# Store session cookies with the cookie key _session

Rails.application.config.session_store :cookie_store, {
  key: "session",
  httponly: true,
  secure: Rails.env.production?,
}
