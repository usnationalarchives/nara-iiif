module ActionHelper

  # Returns the current controller/action name, formatted like routes.rb
  # Example: "homepage#index"
  def current_action
    "#{controller_name}\##{action_name}"
  end

  # Checks if the current_action matches a string or a set of strings
  def action_is?(array_of_actions)
    array_of_actions.include? current_action
  end

  # Returns a fully-qualified URL to a file in /public
  # Will not actually check if the file is there
  def public_file_url(path_part = "")
    return "#{root_url}#{path_part}"
  end

  # Returns the current fully-qualified URL, without parameters
  def current_url
    url_for(only_path:false)
  end

  # Returns the current path, without parameters
  def current_path
    url_for(only_path:true)
  end

end
