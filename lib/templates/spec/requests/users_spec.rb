# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /user/edit', type: :request do
  let(:user_to_edit) { create(:user, email: 'something@example.com') }

  context 'when authenticated' do
    it 'responds with success for html requests' do
      get edit_user_url(as: user_to_edit, id: user_to_edit)
      expect(response).to have_http_status(:success)
    end

    it 'raises an error for json requests' do
      expect {
        get edit_user_url(as: user_to_edit, id: user_to_edit, format: :json)
      }.to raise_error(ActionController::UnknownFormat)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path for html requests' do
      get edit_user_url(user_to_edit)
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      get edit_user_url(user_to_edit, format: :json)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.describe 'PATCH /user', type: :request do
  let(:user_to_edit) { create(:user, email: 'something@example.com') }
  let(:new_attributes) do
    { email: 'new_email_address@example.com' }
  end

  context 'when authenticated' do
    context 'and the parameters are valid' do
      context 'and it is a html request' do
        before(:each) do
          patch user_url(as: user_to_edit, id: user_to_edit), params: {
            user: new_attributes
          }
        end

        it 'updates the User' do
          user_to_edit.reload
          new_attributes.each { |k, v| expect(user_to_edit.send(k)).to eq(v) }
        end

        it 'redirects to the User edit page' do
          expect(response).to redirect_to(edit_user_url(user_to_edit))
        end

        it 'sets a flash message' do
          expect(request.flash[:notice]).to eq(I18n.t('profile.update.success'))
        end
      end

      context 'and it is a json request' do
        before(:each) do
          patch user_url(as: user_to_edit, id: user_to_edit, format: :json), params: {
            user: new_attributes
          }
        end

        it 'updates the User' do
          user_to_edit.reload
          new_attributes.each { |k, v| expect(user_to_edit.send(k)).to eq(v) }
        end

        it 'responds with ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'it returns the updated user in the response body' do
          parsed_body = JSON.parse(response.body)
          new_attributes.each do |k, v|
            expect(parsed_body[k.to_s]).to eq(v)
          end
        end
      end
    end

    context 'and the parameters are invalid' do
      let(:invalid_attributes) do
        { email: nil }
      end

      it 'responds with success for html requests' do
        patch user_url(as: user_to_edit, id: user_to_edit), params: {
          user: invalid_attributes
        }
        expect(response).to have_http_status(:success)
      end

      it 'responds with unprocessable entity for json requests' do
        patch user_url(as: user_to_edit, id: user_to_edit, format: :json), params: {
          user: invalid_attributes
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'when not authenticated' do
    it 'redirects to the sign in path for html requests' do
      patch user_url(user_to_edit), params: { user: new_attributes }
      expect(response).to redirect_to(sign_in_path)
    end

    it 'responds with unauthorized for json requests' do
      patch user_url(user_to_edit, format: :json), params: { user: new_attributes }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
