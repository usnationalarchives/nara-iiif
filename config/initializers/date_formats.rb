# Additional to date formats are usable by DateTime.to_s
# This example lets you call User.created_at.to_s(:simple)
# Time::DATE_FORMATS[:simple] = "%b %e, %Y"

formats = {
  datetime_short: "%m/%d/%Y &ndash; %l:%M%P",
  datetime_pretty: "%B %e, %Y &ndash; %l:%M%P",
  date_pretty: "%B %-d, %Y",
  admin: "%Y-%m-%d %I:%M %P",
  time_ago: lambda { |time|
    ActionController::Base.helpers.
      distance_of_time_in_words_to_now(time).
      sub("about","").squish << " ago"
  },
}

formats.each do |format, value|
  Time::DATE_FORMATS[format] = value
  DateTime::DATE_FORMATS[format] = value
end
