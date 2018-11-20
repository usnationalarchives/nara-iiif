# Touch up some of Rails’ Postgres column mappings.
# https://twitter.com/leinweber/status/700025200079843328

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES.tap do |t|

  # Allow primary keys to grow to 64-bit integers
  t[:primary_key] = {name:"bigserial primary key"}

  # Always record a full timestamp
  t[:datetime] = {name:"timestamptz"}
  t[:timestamp] = {name:"timestamptz"}

end
