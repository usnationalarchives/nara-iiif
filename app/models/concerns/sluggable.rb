# -----------------------------------------------------------------------------
# Sluggable
# Enforce a valid URL slug, and build nice URLs
# -----------------------------------------------------------------------------
# This concern requires that you create a text field on your model such that
#
#   add_column :people, :slug, :text, null:false, index:true
#
# Afterward, the model will enforce that:
#
#   1. The slug is at least 3 characters
#   2. The slug begins with a letter
#   3. The slug only contains lowercase letters, numbers, and dashes
#   4. Dashes can’t appear at the end of the slug, or one after each other
#   5. The slug is unique
#
# You need to enforce maximum length as needed, outside of this concern.
# You can also modify this file to include additional reserved words as forbidden slugs.

module Sluggable

  extend ActiveSupport::Concern

  included do

    validates :slug, {
      uniqueness: true,
      presence: true,
      length: {
        minimum: 3,
      },
      format: {
        # Editorial slug regex http://rubular.com/r/WblL37gYs0
        with: %r{\A[a-z]{1}(-(?!-)|[a-z0-9])+(?<!-)\z}x,
        message: %{
          not a valid URL slug;
          may only be lowercase letters, numbers, and dashes, and must start with a letter
        }.squish,
      },
      exclusion: {
        message: "`%{value}` is a reserved word, please choose a different slug",
        # Add additonal reserved slugs here
        in: %w[
          400
          404
          406
          422
          500
          503
          504
          admin
          api
          delete
          edit
          index
          login
          logout
          page
          post
          preview
          put
          show
          view
        ],
      },
    }

  end

end
