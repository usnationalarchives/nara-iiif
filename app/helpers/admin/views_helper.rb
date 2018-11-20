module Admin::ViewsHelper

  def monospace(inner_html)
    if inner_html.present?
      content_tag :span, class:"monospace" do
        inner_html
      end
    else
      nil
    end
  end

  # Returns the string "Yes" or "No" if `bool` is true or false, respectively
  def yesno(bool)
    bool ? "Yes" : "No"
  end

  def naked_link(url)
    if url.present?
      link_to(url, url, target:"_blank")
    else
      nil
    end
  end

  def slug_link(url)
    if url.present?
      link_to("/" << url.split("/").last, url, target: "_blank")
    else
      nil
    end
  end

  def original_file_details(attachment)
    if attachment.present?
      monospace %{
        #{attachment.original_filename}
        #{attachment.content_type}
        #{number_with_delimiter(attachment.size/1024)} KB
      }
    end
  end

  def status_pill(status)
    color = case status
    when "published"
      color = "green"
    when "draft"
      color = "grey"
    else
      color = "blue"
    end

    pill(status, color: color)
  end

  def type_lowercase(resource)
    resource.class.table_name.humanize.singularize.downcase
  end

end
