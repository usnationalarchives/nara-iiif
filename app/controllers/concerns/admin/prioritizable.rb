module Admin::Prioritizable

  extend ActiveSupport::Concern

  def move_up
    resource = @managed_class.klass.find_by_id(params[:id])
    resource.move_up!
    flash[:success] = "The #{@managed_class.model_name.human.titleize} “#{Tolaria.display_name(resource)}” was moved up."
    redirect_to url_for([:admin, @managed_class.klass])
  end

  def move_down
    resource = @managed_class.klass.find_by_id(params[:id])
    resource.move_down!
    flash[:success] = "The #{@managed_class.model_name.human.titleize} “#{Tolaria.display_name(resource)}” was moved down."
    redirect_to url_for([:admin, @managed_class.klass])
  end

end
