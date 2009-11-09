# Base Rails template for setting up a new project.
TEMPLATE_ROOT = "./rails-templates"

['test-frameworks.rb', 'formtastic.rb', 'authlogic.rb', 'standard.rb', 'git.rb'].each do |template|
  load_template "#{TEMPLATE_ROOT}/#{template}"
end