TEMPLATE_ROOT = "/Users/bob/Dev/rails-templates"

TEMPLATES = [
  'test-frameworks.rb', 'formtastic.rb', 'authlogic.rb', 'standard.rb', 
  'metric_fu.rb',       'capistrano.rb'
]

TEMPLATES.each { |t| load_template File.join(TEMPLATE_ROOT, t) }

run "rake rails:freeze:gems"
run "rake gems:install"
run "rake gems:unpack"
run "rake gems:unpack:dependencies"
run "rake gems:build"

load_template File.join(TEMPLATE_ROOT, 'git.rb')
