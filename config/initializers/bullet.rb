# In development mode, Bullet logs suggestions on optimizing
# your database queries to STDOUT

if defined?(Bullet) && Rails.env.development?
  Bullet.enable = true
  Bullet.rails_logger = true
end
