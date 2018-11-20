# -----------------------------------------------------------------------------
# EditorialSluggable generates automatic newspaper-like URL slugs
# -----------------------------------------------------------------------------
# This concern looks for one of these fields on your model:
#
#   name title label full_name slug
#
# The editoral_slug method will then return an automatically-generated
# newspaper-style slug based on the field above
#
# For example, if your title is "My Story" and your id is 15
# then you will get back
#
#   my-story-15
#
# The concern also adds a convenience function for searching
# based on the full editorial slug
#
#   Klass.find_by_editorial_slug(params[:slug])
#
# where params[:slug] was "my-story-15" or similar

module EditorialSluggable

  extend ActiveSupport::Concern

  EDITORIAL_SLUG_FIELDS = [:name, :title, :label, :full_name, :slug]

  class_methods do

    def find_by_editorial_slug(slug)
      find_by_id(slug.to_s.split("-").last)
    end

  end

  def editorial_slug
    return @editorial_slug ||= begin
      EDITORIAL_SLUG_FIELDS.each do |field|
        if self.respond_to?(field)
          return self.send(field).to_s.parameterize.truncate(150, omission:"", separator:"-") << "-#{self.id}"
        end
      end
    end
  end

end
