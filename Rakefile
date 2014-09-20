require 'rspec/core/rake_task'
require './user'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :digest, [:user, :secret] do |t, args|
  args.with_defaults secret: ENV['SECRET']
  digest = User.new(args[:user]).digest(args[:secret])
  puts "digest: #{digest}"
end
