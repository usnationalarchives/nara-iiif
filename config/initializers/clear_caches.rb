# Ensure there’s a cache directory, some versions of Rails do not set this up.
FileUtils.mkdir_p "#{Rails.root}/tmp/cache"

# Clear any Rails caches on application boot or restart.
# This prevents "ghost" frontend assets or views from surviving a restart.
# Does not run when Rails is started via a `rake` or `rails` task.
unless File.basename($0).include?("rake") || File.basename($0).include?("rails")
  Rails.cache.clear
end
