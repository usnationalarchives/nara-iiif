module MarkupHelper

  # ---------------------------------------------------------------------------
  # TEXT TRANSFORMATIONS
  # ---------------------------------------------------------------------------

  # Pass a block of text through the Markdown rendering engine
  def markdown(text)
    Rails::Markdown.render(text)
  end

  # Converts dumb quote pairs in the given string into fancy quotes
  def fq(stringy = "")
    stringy.gsub(/"(.*)"/, "\u201c\\1\u201d").gsub(/'(.*)'/, "\u2018\\1\u2019")
  end

  # Adds a non-breaking space between the last words of text
  # The second parameter is the number of words you want to preserve on a line
  def uw(text, words: 2)
    arry = text.split(" ")
    arry.push arry.pop(words).join("\u00a0")
    arry.join(" ")
  end

  # Returns a given URI string without the protocol or query params, for display purposes
  def pretty_uri(uri)
    uri = URI.parse(uri)
    return "#{uri.host}#{uri.path}"
  end

  # Converts pairs of stars (*) in the given text to <em> or <strong> tags, like Markdown
  def inline_stars(text)
    text = text.gsub /\*{2}(.*?)\*{2}/, "<strong>\\1</strong>"
    text = text.gsub /\*{1}(.*?)\*{1}/, "<em>\\1</em>"
    return text.html_safe
  end

  # Like number_to_phone, but correctly handles international phone numbers too
  def number_to_international_phone(number)
    if number.length < 11
      number_to_phone(number, country_code:1, delimiter:" ", area_code:true)
    else
      phone_number = number[-10..-1]
      country_code = number.chars.reverse.drop(10).reverse.join("")
      number_to_phone(phone_number, country_code:country_code, delimiter:" ", area_code:true)
    end
  end

  # ---------------------------------------------------------------------------
  # RSS BUILDER
  # ---------------------------------------------------------------------------

  # Build a tag:* property for RSS unique fingerprints
  # `object` must be an ActiveRecord::Base descendant
  def rss_tag_uri_for(object)
    "tag:#{request.host},#{object.created_at.year}:#{object.class.to_s}:#{object.id}"
  end

  # ---------------------------------------------------------------------------
  # TAG CREATION
  # ---------------------------------------------------------------------------

  # Returns a <time> tag wrapping the given datetime
  # The interior phrase uses distance_of_time_in_words_to_now
  def time_ago_tag(datetime)
    return time_tag(datetime, datetime.to_s(:time_ago))
  end

  # Insert inline SVG with custom attributes (does not optimize SVG)
  # Example: <%= svg("icons/twitter", class:"icon--twitter", width:"36", height:"36") %>
  def svg(filename, options = {})
    Rails.cache.fetch(["svg", filename, options]) do
      assets = Rails.application.assets
      file = assets.find_asset(filename).source.force_encoding("UTF-8")
      # Parse as XML to prevent camelCase attributes from being lowercased
      doc = Nokogiri::XML.parse(file)
      svg = doc.at_css "svg"

      # These attributes are unnecessary when inlining the SVG
      doc.xpath('.//@baseProfile').remove
      doc.xpath('.//@version').remove
      doc.xpath('.//@xmlns').remove

      # Get the viewBox dimensions
      viewBox = svg.attr("viewBox").split(" ")
      viewBoxWidth = viewBox[2].to_i
      viewBoxHeight = viewBox[3].to_i

      # Prevent SVG from gaining focus in IE 10+
      svg["focusable"] = "false"

      if options[:class].present?
        svg["class"] = options[:class].to_s
      end

      if options[:height].present?
        svg["height"] = options[:height].to_s

        # Automatically calculate the width using the viewBox dimensions if a width was provided
        if !options[:width].present?
          # Add “to_f” to one of the operands to prevent Ruby from omitting the decimal when diving whole integers
          # https://stackoverflow.com/a/5503586/673457
          svg["width"] = (options[:height].to_i * (viewBoxWidth.to_f / viewBoxHeight)).round(2).to_s
        end
      end

      if options[:width].present?
        svg["width"] = options[:width].to_s

        # Automatically calculate the height if not defined using the viewBox dimensions
        if !options[:height].present?
          svg["height"] = (options[:width].to_i * (viewBoxHeight.to_f / viewBoxWidth)).round(2).to_s
        end
      end

      # Preserve aspect ratio by default
      if options[:aspect].present?
        svg["preserveAspectRatio"] = options[:aspect]
      else
        svg["preserveAspectRatio"] = "xMidYMid meet"
      end

      # Add accessible title and descirption
      if options[:title].present? || options[:desc].present?
        uuid = SecureRandom.hex(3)
        title_id = "title-" + uuid
        desc_id = "desc-" + uuid

        # Add title tag
        if options[:title].present?
          svg["aria-labelledby"] = options[:desc].present? ? title_id + " " + desc_id : title_id
          title_tag = content_tag :title, options[:title], id: title_id
          svg.prepend_child(title_tag)
        end

        # Add desc tag
        if options[:desc].present?
          svg["aria-labelledby"] = options[:title].present? ? title_id + " " + desc_id : desc_id
          desc_tag = content_tag :desc, options[:desc], id: desc_id
          svg.prepend_child(desc_tag)
        end
      end

      # Default to role="img" unless otherwise specified
      # https://www.w3.org/TR/wai-aria/roles#role_definitions
      if options[:role].present?
        svg["role"] = options[:role]
      else
        svg["role"] = "img"
      end

      # Hide from screen readers if no ARIA text provided or custom role defined
      if options[:title].blank? && options[:desc].blank? && options[:role].blank?
        svg["aria-hidden"] = "true"
        svg["role"] = "presentation"
      end

      return raw svg
    end
  end

end
