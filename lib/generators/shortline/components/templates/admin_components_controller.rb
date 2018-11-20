class Admin::ComponentsController < Tolaria::ResourceController

  def destroy
    @resource = Component.find(params[:id])
    @resource.destroy
    flash[:success] = "The #{@managed_class.model_name.human.downcase} was successfully deleted."
    redirect_to component_redirect_path
  end

  def move_up_in_collection
    @resource = @managed_class.klass.find_by_id(params[:id])
    @resource.move_up_in_collection!
    flash[:success] = "The #{@managed_class.model_name.human.downcase} was successfully moved up."
    return redirect_to component_redirect_path
  end

  def move_down_in_collection
    @resource = @managed_class.klass.find_by_id(params[:id])
    @resource.move_down_in_collection!
    flash[:success] = "The #{@managed_class.model_name.human.downcase} was successfully moved down."
    return redirect_to component_redirect_path
  end

  private

    def component_redirect_path
      url_for([:admin, @resource.componentable])
    end

    def form_completion_redirect_path(managed_class, resource = nil)
      return url_for([:admin, @resource.componentable])
    end

end
