# Rails template for setting up formtastic
gem "formtastic"

generate :formtastic

plugin 'validation_reflection', 
       :git => 'git://github.com/redinger/validation_reflection.git'

download "formtastic/formtastic_changes.css", 
         "public/stylesheets/formtastic_changes.css"
