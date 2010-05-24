TEMPLATE_ROOT = "/Users/bob/Dev/rails-templates"

# Base Rails template for setting up a new project.
['test-frameworks.rb', 'formtastic.rb', 'authlogic.rb', 
 'standard.rb', 'metric_fu.rb'].each do |template|
  load_template File.join(TEMPLATE_ROOT, template)
end

run "rake rails:freeze:gems"
run "rake gems:install"
run "rake gems:unpack"
run "rake gems:unpack:dependencies"
run "rake gems:build"

load_template File.join(TEMPLATE_ROOT, 'git.rb')
