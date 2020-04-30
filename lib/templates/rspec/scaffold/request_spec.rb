require 'rails_helper'

<% unless options[:singleton] -%>
<% module_namespacing do -%>
RSpec.describe 'GET /<%= name.underscore.pluralize %>', <%= type_metatag(:request) %> do
  context 'when authenticated' do
    it 'responds with success for html requests' do
      get <%= index_helper %>_url(as: create(:user))
      expect(response).to have_http_status(:success)
    end

    it 'responds with success for json requests' do
      get <%= index_helper %>_url(
        as: create(:user),
        format: :json,
        'order[0][column' => 0
      )

      expect(response).to have_http_status(:success)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path for html requests' do
      get <%= index_helper %>_url
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      get <%= index_helper %>_url(format: :json, 'order[0][column' => 0)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
<% end -%>
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'GET /<%= name.underscore %>', <%= type_metatag(:request) %> do
  let(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }

  context 'when authenticated' do
    it 'responds with success for html requests' do
      get <%= singular_route_name %>_url(as: create(:user), id: <%= singular_table_name %>)
      expect(response).to have_http_status(:success)
    end

    it 'responds with success for json requests' do
      get <%= singular_route_name %>_url(as: create(:user), id: <%= singular_table_name %>, format: :json)
      expect(response).to have_http_status(:success)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path for html requests' do
      get <%= singular_route_name %>_url(<%= singular_table_name %>)
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      get <%= singular_route_name %>_url(id: <%= singular_table_name %>, format: :json)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'GET /<%= name.underscore %>/new', <%= type_metatag(:request) %> do
  context 'when authenticated' do
    it 'responds with success for html requests' do
      get <%= new_helper %>(as: create(:user))
      expect(response).to have_http_status(:success)
    end

    it 'raises an error for json requests' do
      expect {
        get <%= new_helper %>(as: create(:user), format: :json)
      }.to raise_error(ActionController::UnknownFormat)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path for html requests' do
      get <%= new_helper %>
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      get <%= new_helper %>(format: :json)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'GET /<%= name.underscore %>/edit', <%= type_metatag(:request) %> do
  let(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }

  context 'when authenticated' do
    it 'responds with success for html requests' do
      get edit_<%= singular_route_name %>_url(as: create(:user), id: <%= singular_table_name %>)
      expect(response).to have_http_status(:success)
    end

    it 'raises an error for json requests' do
      expect {
        get edit_<%= singular_route_name %>_url(
          as: create(:user),
          id: <%= singular_table_name %>,
          format: :json
        )
      }.to raise_error(ActionController::UnknownFormat)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path for html requests' do
      get edit_<%= singular_route_name %>_url(<%= singular_table_name %>)
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      get edit_<%= singular_route_name %>_url(<%= singular_table_name %>, format: :json)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'POST /<%= name.underscore.pluralize %>', <%= type_metatag(:request) %> do
  context 'when authenticated' do
    let(:user) { create(:user) }

    context 'and the parameters are valid' do
      let(:valid_attributes) { attributes_for(:<%= singular_table_name %>) }

      context 'and it is a html request' do
        it 'creates a new <%= class_name %>' do
          expect {
            post <%= index_helper %>_url(as: user), params: { <%= singular_table_name %>: valid_attributes }
          }.to change(<%= class_name %>, :count).by(1)
        end

        it 'redirects to the created <%= class_name %>' do
          post <%= index_helper %>_url(as: user), params: { <%= singular_table_name %>: valid_attributes }
          expect(response).to redirect_to(<%= singular_route_name %>_url(<%= class_name %>.last))
        end

        it 'sets a flash message' do
          post <%= index_helper %>_url(as: user), params: { <%= singular_table_name %>: valid_attributes }
          expect(request.flash[:notice]).to \
            eq(I18n.t('flash.created', model: '<%= class_name %>'))
        end
      end

      context 'and it is a json request' do
        it 'creates a new <%= class_name %>' do
          expect {
            post <%= index_helper %>_url(as: user, format: :json), params: { <%= singular_table_name %>: valid_attributes }
          }.to change(<%= class_name %>, :count).by(1)
        end

        it 'responds with created status' do
          post <%= index_helper %>_url(as: user, format: :json), params: { <%= singular_table_name %>: valid_attributes }
          expect(response).to have_http_status(:created)
        end

        it 'it returns the created <%= singular_table_name %> in the response body' do
          post <%= index_helper %>_url(as: user, format: :json), params: { <%= singular_table_name %>: valid_attributes }
          parsed_body = JSON.parse(response.body)
          valid_attributes.each do |k, v|
            expect(parsed_body[k.to_s]).to eq(v)
          end
        end
      end
    end

    context 'and the parameters are invalid' do
      let(:invalid_attributes) do
        skip('Add a hash of invalid attributes for <%= class_name %>')
      end

      context 'and it is a html request' do
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

      context 'and it is a json request' do
        it 'does not create a new <%= class_name %>' do
          expect {
            post <%= index_helper %>_url(as: user, format: :json), params: { <%= singular_table_name %>: invalid_attributes }
          }.to change(<%= class_name %>, :count).by(0)
        end

        it 'responds with unprocessable entity' do
          post <%= index_helper %>_url(as: user, format: :json), params: { <%= singular_table_name %>: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path for html requests' do
      post <%= index_helper %>_url, params: { <%= singular_table_name %>: {} }
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      post <%= index_helper %>_url(format: :json), params: { <%= singular_table_name %>: {} }
      expect(response).to have_http_status(:unauthorized)
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
      context 'and it is a html request' do
        before(:each) do
          patch <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>), params: {
            <%= singular_table_name %>: new_attributes
          }
        end

        it 'updates the <%= class_name %>' do
          <%= singular_table_name %>.reload
          new_attributes.each { |k, v| expect(<%= singular_table_name %>.send(k)).to eq(v) }
        end

        it 'redirects to the <%= class_name %>' do
          expect(response).to redirect_to(<%= singular_route_name %>_url(<%= singular_table_name %>))
        end

        it 'sets a flash message' do
          expect(request.flash[:notice]).to \
            eq(I18n.t('flash.updated', model: '<%= class_name %>'))
        end
      end

      context 'and it is a json request' do
        before(:each) do
          patch <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>, format: :json), params: {
            <%= singular_table_name %>: new_attributes
          }
        end

        it 'updates the <%= class_name %>' do
          <%= singular_table_name %>.reload
          new_attributes.each { |k, v| expect(<%= singular_table_name %>.send(k)).to eq(v) }
        end

        it 'responds with ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'it returns the updated <%= singular_table_name %> in the response body' do
          <%= singular_table_name %>.reload
          new_attributes.each do |k, v|
            expect(<%= singular_table_name %>.send(k)).to eq(v)
          end
        end
      end
    end

    context 'and the parameters are invalid' do
      let(:invalid_attributes) do
        skip('Add a hash of invalid attributes for <%= class_name %>')
      end

      it 'responds with success for html requests' do
        patch <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>), params: {
          <%= singular_table_name %>: invalid_attributes
        }
        expect(response).to have_http_status(:success)
      end

      it 'responds with unprocessable entity for json requests' do
        patch <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>, format: :json), params: {
          <%= singular_table_name %>: invalid_attributes
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'when not authenticated' do
    it 'redirects to the sign in path for html requests' do
      patch <%= singular_route_name %>_url(<%= singular_table_name %>), params: { <%= singular_table_name %>: new_attributes }
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      patch <%= singular_route_name %>_url(<%= singular_table_name %>, format: :json), params: { <%= singular_table_name %>: new_attributes }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
<% end -%>

<% module_namespacing do -%>
RSpec.describe 'DELETE /<%= name.underscore %>', <%= type_metatag(:request) %> do
  let!(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }

  context 'when authenticated' do
    let(:user) { create(:user) }

    context 'and it is a html request' do
      it 'deletes the <%= class_name %>' do
        expect {
          delete <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>)
        }.to change(<%= class_name %>, :count).by(-1)
      end

      it 'redirects to the <%= class_name %> index' do
        delete <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>)
        expect(response).to redirect_to(<%= index_helper %>_url)
      end

      it 'sets a flash message' do
        delete <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>)
        expect(request.flash[:notice]).to \
          eq(I18n.t('flash.destroyed', model: '<%= class_name %>'))
      end
    end

    context 'and it is a json request' do
      it 'deletes the <%= class_name %>' do
        expect {
          delete <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>, format: :json)
        }.to change(<%= class_name %>, :count).by(-1)
      end

      it 'responds with something' do
        delete <%= singular_route_name %>_url(as: user, id: <%= singular_table_name %>, format: :json)
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  context 'when not authenticated' do
    it 'redirects to the sign in path for html requests' do
      delete <%= singular_route_name %>_url(<%= singular_table_name %>)
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      delete <%= singular_route_name %>_url(<%= singular_table_name %>, format: :json)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
<% end -%>
