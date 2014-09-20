package 'gawk'

node.set['rvm']['user_installs'] = [
  {
    :user => 'vagrant',
    :default_ruby => 'system',
    :rubies => ['2.1.2'],
    :global_gems => [{ :name => 'bundler' }]
  }
]
