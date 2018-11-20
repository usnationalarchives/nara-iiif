module AutoSluggable

  extend ActiveSupport::Concern

  AUTO_SLUG_FIELDS = [:name, :title, :label, :full_name, :slug]

  included do

    include Sluggable

    before_validation :set_slug

    private

      def set_slug
        AUTO_SLUG_FIELDS.each do |field|
          if self.respond_to?(field)
            return self.slug = self.send(field).to_s.parameterize.truncate(150, {omission: "", separator: "-"})
          end
        end
      end

  end

end
