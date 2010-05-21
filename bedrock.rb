TEMPLATE_ROOT = "/Users/bob/Dev/rails-templates"

# Base Rails template for setting up a new project.
['test-frameworks.rb', 'formtastic.rb', 'authlogic.rb', 
 'standard.rb', 'git.rb'].each do |template|
  load_template File.join(TEMPLATE_ROOT, template)
end
