module ShortcodeHelper

  # ----------------------------------------------------------------
  # CONSTANTS
  # ----------------------------------------------------------------

  SHORTCODE_REGEX = %r{
    ((<(span|p|h1|h2|h3|h4|h5|h6)>)?\[\[([a-z-]+)(.*?)\]\](<\/(span|p|h1|h2|h3|h4|h5|h6)>)?)
  }ix

  SHORTCODE_PARAMETER_REGEX = %r{
    \s(?:              # Parameters are seperated by spaces
      ([\w\d/-]+)  |   # Free-form URL slug identifier, like a YouTube ID
      (\d+)        |   # or a number
      "(.+?)"          # or a string surrounded by backticks
    )
  }ix

  # ----------------------------------------------------------------
  # SHORTCODE ENGINE
  # ----------------------------------------------------------------

  def self.register_shortcode(name, &block)
    method_name = "shortcode_" << name.to_s.parameterize.gsub("-","_")
    self.send(:define_method, method_name, &block)
  end

  # Process shortcodes on a Markdown document
  # Inserts raw HTML that Markdown should ignore

  def expand_shortcodes(document)

    document = document.to_s

    document.scan(SHORTCODE_REGEX).each do |result|

      # The regex scanning returns the whole shortcode sequence,
      # the name of the shortcode command, and the paramters seperately
      sequence = result.first
      shortcode_name = result.second.to_s.gsub("-","_")
      method_name = "shortcode_" << shortcode_name
      parameters = result.third.scan(SHORTCODE_PARAMETER_REGEX).flatten.compact
      puts "  Rendering shortcode `#{shortcode_name}` with parameters #{parameters.inspect}"

      # Attempt to replace the shortcode sequence with the real HTML.
      # If the sequence is invalid we will send a <code>
      # span with plaintext to the Markdown renderer so that
      # authors know it failed (and we don't get an exception)
      html_string = self.try(method_name, *parameters) || "<pre>#{sequence}</pre>"
      document.gsub!(sequence, html_string.squish)

    end

    document

  end

  # ----------------------------------------------------------------
  # SHORTCODE DECLARATIONS
  # Add additional shortcodes here, as needed on your project
  # The block should return a snippet of HTML; usually you want
  # to offload this work to an ERB partial
  # ----------------------------------------------------------------

  register_shortcode "youtube" do |*args|
    render partial:"shared/shortcodes/youtube", locals: {
      id: args.first.to_s, # First param is the YouTube video ID
      title: args.second.to_s, # Second parameter is the video title, for screenreaders
      alternate_uri: args.third.to_s # Optional link to transcript or alternate content
    }
  end

  register_shortcode "vimeo" do |*args|
    render partial:"shared/shortcodes/vimeo", locals: {
      id: args.first.to_i, # First param is the Vimeo video ID
      title: args.second.to_s, # Second parameter is the video title, for screenreaders
      alternate_uri: args.third.to_s # Optional link to transcript or alternate content
    }
  end

  register_shortcode "tweet" do |*args|
    render partial:"shared/shortcodes/tweet", locals: {
      position: "full",
      tweet_id: args.first.to_i, # First param is the Tweet ID
    }
  end

  register_shortcode "tweet-right" do |*args|
    render partial:"shared/shortcodes/tweet", locals: {
      position: "right",
      tweet_id: args.first.to_i, # First param is the Tweet ID
    }
  end

  register_shortcode "tweet-left" do |*args|
    render partial:"shared/shortcodes/tweet", locals: {
      position: "left",
      tweet_id: args.first.to_i, # First param is the Tweet ID
    }
  end

  register_shortcode "instagram" do |*args|
    render partial:"shared/shortcodes/instagram", locals: {
      position: "full",
      post_id: args.first.to_s,
    }
  end

  register_shortcode "instagram-right" do |*args|
    render partial:"shared/shortcodes/instagram", locals: {
      position: "right",
      post_id: args.first.to_s,
    }
  end

  register_shortcode "instagram-left" do |*args|
    render partial:"shared/shortcodes/instagram", locals: {
      position: "left",
      post_id: args.first.to_s,
    }
  end

  register_shortcode "facebook" do |*args|
    render partial:"shared/shortcodes/facebook", locals: {
      position: "full",
      post_fragment: args.first.to_s,
    }
  end

  register_shortcode "facebook-right" do |*args|
    render partial:"shared/shortcodes/facebook", locals: {
      position: "right",
      post_fragment: args.first.to_s,
    }
  end

  register_shortcode "facebook-left" do |*args|
    render partial:"shared/shortcodes/facebook", locals: {
      position: "left",
      post_fragment: args.first.to_s,
    }
  end

  register_shortcode "soundcloud" do |*args|
    render partial:"shared/shortcodes/soundcloud", locals: {
      id: args.first.to_i, # First param is the track ID
    }
  end

  # Project-specific Shortcodes

  register_shortcode "image" do |*args|
    image = Image.find_by_id(args.first.to_i)
    return nil unless image
    render partial:"shared/shortcodes/image", locals: {
      image: image,
      caption: args.second.presence
    }
  end

  register_shortcode "image-left" do |*args|
    image = Image.find_by_id(args.first.to_i)
    return nil unless image
    render partial:"shared/shortcodes/image", locals: {
      position: "left",
      image: image,
      caption: args.second.presence
    }
  end

  register_shortcode "image-right" do |*args|
    image = Image.find_by_id(args.first.to_i)
    return nil unless image
    render partial:"shared/shortcodes/image", locals: {
      position: "right",
      image: image,
      caption: args.second.presence
    }
  end

end
