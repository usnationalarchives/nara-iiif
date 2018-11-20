desc "Print out a tight Gemfile config based on your Gemfile.lock"
task :patchspec do

  require "bundler"

  @lockfile = Bundler::LockfileParser.new(Bundler.read_file("./Gemfile.lock"))

  @lockfile.dependencies.each do |dependency|

    @lockfile.specs.each do |spec|
      if dependency.name == spec.name
        puts %{gem "#{spec.name}", "~> #{spec.version}"}
      end
    end

  end

end

