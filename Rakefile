unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
end

namespace :user do
  task :digest, [:user, :secret] do |t, args|
    require './models/user'
    digest = User.new(args[:user], args[:secret]).digest
    puts "digest: #{digest}"
  end
end

namespace :cache do
  require './models/cache'
  require './models/media'

  task :flush do
    print 'Flushing cache... '
    Cache.instance.flush
    print 'done'
  end

  task :warm do
    print 'Fetching recent content... '
    Media.recent
    puts 'done'
  end
end
