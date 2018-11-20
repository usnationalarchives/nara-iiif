# -----------------------------------------------------------------------
# FRONTEND COMPILED ASSET MANIFEST
# -----------------------------------------------------------------------
# Rails automatically precompiles application.js and application.css
# for production. You can add additional assets by listing them in this array.
# As of Sprockets 3, assets not on this list will raise errors, even in development.
#
# You can use wildcards, ex. libs/* or themes/*.scss.
# Images and fonts are handled automatically.
# Favicons and other strange files may need to be added manually.

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( main.css )
