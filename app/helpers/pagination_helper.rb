module PaginationHelper

  def pagination_info(collection)
    if collection.any?
      if collection.total_pages == 1
        "Showing #{"all" if collection.total_count > 1} #{collection.total_count} #{"item".pluralize(collection.total_count)}"
      else
        first = collection.offset_value + 1
        last = collection.last_page? ? collection.total_count : collection.offset_value + collection.limit_value
        "Showing #{first} - #{last} of #{collection.total_count} Items"
      end
    end
  end

end
