# Base Rails template for setting up a new project.
TEMPLATE_ROOT = "http://github.com/thethirdswitch/rails-templates/raw/master"

['test-frameworks.rb', 'formtastic.rb', 'authlogic.rb', 'standard.rb', 'git.rb'].each do |template|
  load_template "#{TEMPLATE_ROOT}/#{template}"
end