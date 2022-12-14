# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/people' do
  # Person. As you add validations to Person, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      last_name: 'テスト',
      last_name_kana: 'てすと',
      first_name: '東雲',
      first_name_kana: 'しののめ',
      copyright_flag: false
    }
  end

  let(:invalid_attributes) do
    {
      last_name: 'テスト　',
      last_name_kana: 'てすと',
      copyright_flag: nil

    }
  end

  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /index' do
    it 'renders a successful response' do
      Person.create! valid_attributes
      get admin_people_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      person = Person.create! valid_attributes
      get admin_person_url(person)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_admin_person_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      person = Person.create! valid_attributes
      get edit_admin_person_url(person)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Person' do
        expect do
          post admin_people_url, params: { person: valid_attributes }
        end.to change(Person, :count).by(1)
      end

      it 'redirects to the created person' do
        post admin_people_url, params: { person: valid_attributes }
        expect(response).to redirect_to(admin_person_url(Person.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Person' do
        expect do
          post admin_people_url, params: { person: invalid_attributes }
        end.not_to change(Person, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post admin_people_url, params: { person: invalid_attributes }
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          last_name: '別名'
        }
      end

      it 'updates the requested person' do
        person = Person.create! valid_attributes
        patch admin_person_url(person), params: { person: new_attributes }
        person.reload
        expect(person.last_name).to eq '別名'
      end

      it 'redirects to the person' do
        person = Person.create! valid_attributes
        patch admin_person_url(person), params: { person: new_attributes }
        person.reload
        expect(response).to redirect_to(admin_person_url(person))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        person = Person.create! valid_attributes
        patch admin_person_url(person), params: { person: invalid_attributes }
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested person' do
      person = Person.create! valid_attributes
      expect do
        delete admin_person_url(person)
      end.to change(Person, :count).by(-1)
    end

    it 'redirects to the people list' do
      person = Person.create! valid_attributes
      delete admin_person_url(person)
      expect(response).to redirect_to(admin_people_url)
    end
  end
end
