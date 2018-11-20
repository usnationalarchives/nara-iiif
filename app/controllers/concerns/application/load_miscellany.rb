# --------------------------------------------------------------------------------
# Application::LoadMiscellany loads all Miscellany records into a globally
# accessible @misc OpenStruct object
# --------------------------------------------------------------------------------
# This concern is included in the ApplicationController and doesnt need to be
# included on individual resource controllers

module Application::LoadMiscellany

  extend ActiveSupport::Concern

  included do

    before_action :load_miscellany, unless: :looking_at_admin?

    protected

    # This filter loads all of the Miscellany objects for each request
    def load_miscellany
      @misc = Rails.cache.fetch("miscellany") do
        misc = OpenStruct.new
        Miscellany.select([:key, :value]).each do |miscellany|
          misc[miscellany.key.to_sym] = miscellany.value
        end
        misc
      end
    end

  end

end
