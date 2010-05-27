root = ENV['LOCATION'] || "~/Dev/rails-templates"
require File.expand_path(File.join(root, "lib/utility"))

about = <<-CODE
\n
|-----------------------------------------------------------------------------|
 Standard Rails template. Uses HAML and SASS for templating/CSS (haml must be
 in $PATH).

 IMPORTANT: This template overwrites several files and is meant to be run on a 
            fresh app.
|-----------------------------------------------------------------------------|
CODE

if yes?(about + "\ncontinue?(y/n)")
  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm README"
  run "rm public/images/rails.png"
  run "cp config/database.yml config/database.yml.sample"
  run "haml --rails ."

  # Layouts
  download root, 'standard/application.html.haml',
    'app/views/layouts/application.html.haml'

  # Stylesheets
  run "mkdir public/stylesheets/sass"
  run "mkdir public/stylesheets/sass/base"

  download root, 'standard/base.sass', 
    'public/stylesheets/sass/base.sass'

  download root, 'standard/_color.sass', 
    'public/stylesheets/sass/base/_color.sass'

  download root, 'standard/_forms.sass', 
    'public/stylesheets/sass/base/_forms.sass'

  download root, 'standard/_formtastic.sass', 
    'public/stylesheets/sass/base/_formtastic.sass'

  download root, 'standard/_reset.sass', 
    'public/stylesheets/sass/base/_reset.sass'

  download root, 'standard/_type.sass', 
    'public/stylesheets/sass/base/_type.sass'

  download root, 'standard/envision.sass',
    'public/stylesheets/sass/envision.sass'

  download root, 'standard/envision-login.sass',
    'public/stylesheets/sass/envision-login.sass'

  # Remove formtastic specific stylesheets if they exist. Formtastic
  # styles are covered by the sass files above
  run "rm 'public/stylesheets/formtastic.css'" if File.exists?('public/stylesheets/formtastic.css')
  run "rm 'public/stylesheets/formtastic_changes.css'" if File.exists?('public/stylesheets/formtastic_changes.css')

  # Images
  run "cp -r #{File.join(root, 'standard/images/*')} public/images"

  # Home Controller
  run "mkdir app/views/home"
  route "map.resource :home, :only => :index"
  route "map.root :controller => 'home', :action => 'index'"

  download root, "standard/home_controller.rb",
    "app/controllers/home_controller.rb"

  download root, "standard/home_controller_test.rb",
    "test/functional/home_controller_test.rb"

  download root, "standard/home_helper.rb",
    "app/helpers/home_helper.rb"

  download root, "standard/home_helper_test.rb",
    "test/unit/helpers/home_helper_test.rb"

  download root, "standard/home.index.html.haml",
    "app/views/home/index.html.haml"
end
