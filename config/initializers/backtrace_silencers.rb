# You can add backtrace silencers for libraries that you're using but don't wish to see in your backtraces.
Rails.backtrace_cleaner.add_silencer { |line| line =~ /bad_request_handling/ }

# You can also remove all the silencers if you're trying to debug a problem that might stem from framework code.
# Rails.backtrace_cleaner.remove_silencers!
