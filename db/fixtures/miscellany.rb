@miscellany = {

  # twitter_username: {
  #   name: "Twitter Username",
  #   description: "The organization's Twitter username (without the @).",
  #   value: "twitter_username"
  # },

}

@miscellany.each do |key, fields|
  Miscellany.seed_once :key do |s|
    s.key = key
    s.name = fields[:name]
    s.description = fields[:description]
    s.value = fields[:value].presence
  end
end
