 require 'rails_helper'

<% unless options[:singleton] -%>
<% module_namespacing do -%>
RSpec.describe 'GET /<%= name.underscore.pluralize %>', <%= type_metatag(:request) %> do
  context 'when authenticated' do
    it 'responds with success' do
      get <%= index_helper %>_url(as: create(:user))
      expect(response).to have_http_status(:success)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path' do
      get <%= index_helper %>_url
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
<% end -%>
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'GET /<%= name.underscore %>', <%= type_metatag(:request) %> do
  let(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }

  context 'when authenticated' do
    it 'responds with success' do
      get <%= singular_route_name %>_url(as: create(:user), id: <%= singular_table_name %>)
      expect(response).to have_http_status(:success)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path' do
      get <%= singular_route_name %>_url(<%= singular_table_name %>)
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'GET /<%= name.underscore %>/new', <%= type_metatag(:request) %> do
  context 'when authenticated' do
    it 'responds with success' do
      get <%= new_helper %>(as: create(:user))
      expect(response).to have_http_status(:success)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path' do
      get <%= new_helper %>
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'GET /<%= name.underscore %>/edit', <%= type_metatag(:request) %> do
  let(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }

  context 'when authenticated' do
    it 'responds with success' do
      get edit_<%= singular_route_name %>_url(as: create(:user), id: <%= singular_table_name %>)
      expect(response).to have_http_status(:success)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path' do
      get edit_<%= singular_route_name %>_url(<%= singular_table_name %>)
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'POST /<%= name.underscore.pluralize %>', <%= type_metatag(:request) %> do
  context 'when authenticated' do
    let(:user) { create(:user) }

    context 'and the parameters are valid' do
      it 'creates a new <%= class_name %>' do
        expect {
          post <%= index_helper %>_url(as: user), params: { <%= singular_table_name %>: attributes_for(:<%= singular_table_name %>) }
        }.to change(<%= class_name %>, :count).by(1)
      end

      it 'redirects to the created <%= class_name %>' do
        post <%= index_helper %>_url(as: user), params: { <%= singular_table_name %>: attributes_for(:<%= singular_table_name %>) }
        expect(response).to redirect_to(<%= singular_route_name %>_url(<%= class_name %>.last))
      end
    end

    context 'and the parameters are invalid' do
      let(:invalid_attributes) do
        skip('Add a hash of invalid attributes for <%= class_name %>')
      end

      it 'does not create a new <%= class_name %>' do
        expect {
          post <%= index_helper %>_url(as: user), params: { <%= singular_table_name %>: invalid_attributes }
        }.to change(<%= class_name %>, :count).by(0)
      end

      it 'responds with success (with the :new template)' do
        post <%= index_helper %>_url(as: user), params: { <%= singular_table_name %>: invalid_attributes }
        expect(response).to have_http_status(:success)
      end
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path' do
      post <%= index_helper %>_url, params: { <%= singular_table_name %>: attributes_for(:<%= singular_table_name %>) }
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'PATCH /<%= name.underscore %>', <%= type_metatag(:request) %> do
  let(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }
  let(:new_attributes) do
    skip('Add a hash of attributes valid for <%= class_name %>')
  end

  context 'when authenticated' do
    let(:user) { create(:user) }

    context 'and the parameters are valid' do
      it 'updates the <%= class_name %>' do
        patch <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>), params: {
          <%= singular_table_name %>: new_attributes
        }
        <%= singular_table_name %>.reload
        new_attributes.each { |k, v| expect(<%= singular_table_name %>.send(k)).to eq(v) }
      end

      it 'redirects to the <%= class_name %>' do
        patch <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>), params: {
          <%= singular_table_name %>: new_attributes
        }
        expect(response).to redirect_to(<%= singular_route_name %>_url(<%= singular_table_name %>))
      end
    end

    context 'and the parameters are invalid' do
      it 'responds with success (with the :edit template)' do
        skip('Add a hash of invalid attributes for <%= class_name %>')
        invalid_attributes = {}
        patch <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>), params: {
          <%= singular_table_name %>: invalid_attributes
        }
        expect(response).to have_http_status(:success)
      end
    end
  end

  context 'when not authenticated' do
    it 'redirects to the sign in path' do
      patch <%= singular_route_name %>_url(<%= singular_table_name %>), params: { <%= singular_table_name %>: new_attributes }
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'DELETE /<%= name.underscore %>', <%= type_metatag(:request) %> do
  context 'when authenticated' do
    let(:user) { create(:user) }

    it 'deletes the <%= class_name %>' do
      <%= singular_table_name %> = create(:<%= singular_table_name %>)
      expect {
        delete <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>)
      }.to change(<%= class_name %>, :count).by(-1)
    end

    it 'redirects to the <%= class_name %> index' do
      <%= singular_table_name %> = create(:<%= singular_table_name %>)
      delete <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>)
      expect(response).to redirect_to(<%= index_helper %>_url)
    end
  end

  context 'when not authenticated' do
    it 'redirects to the sign in path' do
      <%= singular_table_name %> = create(:<%= singular_table_name %>)
      delete <%= singular_route_name %>_url(<%= singular_table_name %>)
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
<% end -%>
