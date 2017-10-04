script 'setup-heroku-toolbelt' do
  interpreter 'bash'
  user  'root'
  code <<-EOF
  set -e
  wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
  EOF
end
