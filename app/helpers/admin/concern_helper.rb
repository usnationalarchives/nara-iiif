module Admin::ConcernHelper

  def priority_column(obj)
    if params[:q].blank? && (not obj.priority_placement.lonely?)
      controls = ""
      unless obj.priority_placement.top?
        url = url_for(controller:"admin/#{obj.class.to_s.tableize}", action:"move_up", id:obj.id)
        controls << link_to(content_tag(:i, nil, class: "icon icon-arrow-up"), url, class: "button -small", method: :put)
      end
      unless (obj.priority_placement.bottom?)
        url = url_for(controller:"admin/#{obj.class.to_s.tableize}", action:"move_down", id:obj.id)
        controls << link_to(content_tag(:i, nil, class: "icon icon-arrow-down"), url, class: "button -small", method: :put)
      end
      controls.html_safe
    end
  end

  def priority_collection_column(obj)
    if params[:q].blank?
      controls = ""
      unless obj == obj.prioritizable_collection.first
        url = url_for(controller:"admin/#{obj.class.to_s.tableize}", action:"move_up_in_collection", id:obj.to_param)
        controls << link_to(content_tag(:i, nil, class: "icon icon-arrow-up"), url, method: :put, class: "button -small")
      end
      unless obj == obj.prioritizable_collection.last
        url = url_for(controller:"admin/#{obj.class.to_s.tableize}", action:"move_down_in_collection", id:obj.to_param)
        controls << link_to(content_tag(:i, nil, class: "icon icon-arrow-down"), url, class:"button -small", method: :put)
      end
      controls.html_safe
    end
  end

  def designation_column(obj)
    if obj.designated?
      link_to "Deactivate", url_for(controller:"admin/#{obj.class.to_s.tableize}", action:"undesignate", id:obj.id), method: :put, class: "button -small"
    else
      link_to "Activate", url_for(controller:"admin/#{obj.class.to_s.tableize}", action:"designate", id:obj.id), method: :put, class: "button -small"
    end
  end

end
