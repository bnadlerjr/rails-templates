require 'rails_helper'
require 'support/shoulda'

<% module_namespacing do -%>
RSpec.describe <%= class_name %>, 'validations', <%= type_metatag(:model) %> do
  # it { should validate_presence_of(:something) }
end
<% end -%>
