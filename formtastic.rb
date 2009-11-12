# Rails template for setting up formtastic
gem "formtastic"

generate :formtastic

plugin 'validation_reflection', :git => 'git://github.com/redinger/validation_reflection.git'
file 'public/stylesheets/formtastic_changes.css', 
     open("http://github.com/thethirdswitch/rails-templates/raw/master/formtastic/formtastic_changes.css").read