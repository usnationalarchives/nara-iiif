module Admin::Designateable

  extend ActiveSupport::Concern

  def designate
    resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
    resource.designate!
    flash[:success] = "The #{@managed_class.model_name.human.titleize} “#{Tolaria.display_name(resource)}” was successfully activated."
    redirect_to url_for([:admin, @managed_class.klass])
  end

  def undesignate
    resource = @managed_class.klass.find_by_id(params[:id]) or raise ActiveRecord::RecordNotFound
    resource.undesignate!
    flash[:success] = "The #{@managed_class.model_name.human.titleize} “#{Tolaria.display_name(resource)}” was successfully deactivated."
    redirect_to url_for([:admin, @managed_class.klass])
  end

end
