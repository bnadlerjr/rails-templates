require 'rails_helper'

RSpec.describe 'GET /user/edit', type: :request do
  let(:user_to_edit) { create(:user, email: 'something@example.com') }

  context 'when authenticated' do
    it 'responds with success' do
      get edit_user_url(as: user_to_edit, id: user_to_edit)
      expect(response).to have_http_status(:success)
    end
  end

  context 'when not authenticated' do
    it 'redirects to sign in path' do
      get edit_user_url(user_to_edit)
      expect(response).to redirect_to(sign_in_path)
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

    context 'and the parameters are invalid' do
      it 'responds with success (with the :edit template)' do
        invalid_attributes = { email: nil }
        patch user_url(as: user_to_edit, id: user_to_edit), params: {
          user: invalid_attributes
        }
        expect(response).to have_http_status(:success)
      end
    end
  end

  context 'when not authenticated' do
    it 'redirects to the sign in path' do
      patch user_url(user_to_edit), params: { user: new_attributes }
      expect(response).to redirect_to(sign_in_path)
    end
  end
end
