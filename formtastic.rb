# Rails template for setting up formtastic
gem "formtastic"

generate :formtastic

plugin 'validation_reflection', :git => 'git://github.com/redinger/validation_reflection.git'

file 'public/stylesheets/formtastic_changes.css', <<-CODE
/* -------------------------------------------------------------------------------------------------

Load this stylesheet after formtastic.css in your layouts to override the CSS to suit your needs.
This will allow you to update formtastic.css with new releases without clobbering your own changes.

For example, to make the inline hint paragraphs a little darker in color than the standard #666:

form.formtastic fieldset ol li p.inline-hints { color:#333; }

--------------------------------------------------------------------------------------------------*/
form.formtastic fieldset ol li label { text-align:right; }
form.formtastic fieldset ol li label:after { content:": "; }
form.formtastic fieldset ol li.required abbr { color:#ff0000; }
form.formtastic fieldset legend span { color:#ff0000; }

.error {background:#FBE3E4;color:#8a1f11;border-color:#FBC2C4;}
.notice {background:#FFF6BF;color:#514721;border-color:#FFD324;}
.success {background:#E6EFC2;color:#264409;border-color:#C6D880;}
.error a {color:#8a1f11;}
.notice a {color:#514721;}
.success a {color:#264409;}
CODE