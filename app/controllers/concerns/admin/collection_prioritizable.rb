# -----------------------------------------------------------------------------
# The Collection Prioritizable controller concern provides priority assignment
# methods to use in conjunction with the CollectionPrioritizable model concern
# -----------------------------------------------------------------------------
# This concern requires that you call the following in your controller
#
#   prioritizable parent: :parent_class_name_singular
#
#

module Admin::CollectionPrioritizable

  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :parent_klass

    private

    def prioritizable(opts={})
      @parent_klass = opts[:parent].to_s
    end
  end

  def move_up_in_collection
    resource = @managed_class.klass.find_by_id(params[:id])
    resource.move_up_in_collection!
    flash[:success] = "The #{@managed_class.model_name.human.titleize} “#{Tolaria.display_name(resource)}” was moved up."
    redirect_to self.send("admin_#{self.class.parent_klass}_path", resource.send("#{self.class.parent_klass}_id"))
  end

  def move_down_in_collection
    resource = @managed_class.klass.find_by_id(params[:id])
    resource.move_down_in_collection!
    flash[:success] = "The #{@managed_class.model_name.human.titleize} “#{Tolaria.display_name(resource)}” was moved down."
    redirect_to self.send("admin_#{self.class.parent_klass}_path", resource.send("#{self.class.parent_klass}_id"))
  end

end
