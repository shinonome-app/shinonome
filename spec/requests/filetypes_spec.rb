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

RSpec.describe '/filetypes', type: :request do
  # Filetype. As you add validations to Filetype, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Filetype.create! valid_attributes
      get filetypes_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      filetype = Filetype.create! valid_attributes
      get filetype_url(filetype)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_filetype_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      filetype = Filetype.create! valid_attributes
      get edit_filetype_url(filetype)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Filetype' do
        expect do
          post filetypes_url, params: { filetype: valid_attributes }
        end.to change(Filetype, :count).by(1)
      end

      it 'redirects to the created filetype' do
        post filetypes_url, params: { filetype: valid_attributes }
        expect(response).to redirect_to(filetype_url(Filetype.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Filetype' do
        expect do
          post filetypes_url, params: { filetype: invalid_attributes }
        end.to change(Filetype, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post filetypes_url, params: { filetype: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested filetype' do
        filetype = Filetype.create! valid_attributes
        patch filetype_url(filetype), params: { filetype: new_attributes }
        filetype.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the filetype' do
        filetype = Filetype.create! valid_attributes
        patch filetype_url(filetype), params: { filetype: new_attributes }
        filetype.reload
        expect(response).to redirect_to(filetype_url(filetype))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        filetype = Filetype.create! valid_attributes
        patch filetype_url(filetype), params: { filetype: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested filetype' do
      filetype = Filetype.create! valid_attributes
      expect do
        delete filetype_url(filetype)
      end.to change(Filetype, :count).by(-1)
    end

    it 'redirects to the filetypes list' do
      filetype = Filetype.create! valid_attributes
      delete filetype_url(filetype)
      expect(response).to redirect_to(filetypes_url)
    end
  end
end
