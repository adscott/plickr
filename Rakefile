unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
end

task :digest, [:user, :secret] do |t, args|
  require './user'
  args.with_defaults secret: ENV['SECRET']
  digest = User.new(args[:user]).digest(args[:secret])
  puts "digest: #{digest}"
end
