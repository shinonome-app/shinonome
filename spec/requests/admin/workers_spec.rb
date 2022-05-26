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

RSpec.describe '/admin/workers', type: :request do
  # Worker. As you add validations to Worker, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      name: 'test worker',
      name_kana: 'てすとわーかー',
      sortkey: 'てすとわーかー',
      worker_secret_attributes: {
        email: 'test-worker1@example.com',
        note: 'this is a test',
        url: 'https://example.com/workers/1',
        user_id: user.id
      }
    }
  end

  let(:valid_attributes_without_user) do
    {
      name: 'test worker',
      name_kana: 'てすとわーかー',
      sortkey: 'てすとわーかー',
      worker_secret_attributes: {
        email: 'test-worker1@example.com',
        note: 'this is a test',
        url: 'https://example.com/workers/1'
      }
    }
  end

  let(:invalid_attributes) do
    {
      name: 'test worker',
      name_kana: 'てすとわーかー',
      sortkey: 'てすとわーかー',
      worker_secret_attributes: {
        email: nil,
        note: 'this is a test',
        url: 'https://example.com/workers/1'
      }
    }
  end

  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /' do
    it 'renders a successful response' do
      Worker.create! valid_attributes
      get admin_workers_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      worker = Worker.create! valid_attributes
      get admin_worker_url(worker)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_admin_worker_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      worker = Worker.create! valid_attributes
      get edit_admin_worker_url(worker)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Worker' do
        expect do
          post admin_workers_url, params: { worker: valid_attributes_without_user }
        end.to change(Worker, :count).by(1)
      end

      it 'redirects to the created worker' do
        post admin_workers_url, params: { worker: valid_attributes_without_user }
        expect(response).to redirect_to(admin_worker_url(Worker.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Worker' do
        expect do
          post admin_workers_url, params: { worker: invalid_attributes }
        end.to change(Worker, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post admin_workers_url, params: { worker: invalid_attributes }
        expect(response.successful?).to be_falsey
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'test worker2',
          name_kana: 'てすとわーかー',
          sortkey: 'てすとわーかー',
          worker_secret_attributes: {
            email: 'test-worker2@example.com',
            note: 'this is a test',
            url: 'https://example.com/workers/1'
          }
        }
      end

      it 'updates the requested worker' do
        worker = Worker.create! valid_attributes
        patch admin_worker_url(worker), params: { worker: new_attributes }
        worker.reload
        expect(worker.name).to eq 'test worker2'
      end

      it 'redirects to the worker' do
        worker = Worker.create! valid_attributes
        patch admin_worker_url(worker), params: { worker: new_attributes }
        worker.reload
        expect(response).to redirect_to(admin_worker_url(worker))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        worker = Worker.create! valid_attributes
        patch admin_worker_url(worker), params: { worker: invalid_attributes }
        expect(response.successful?).to be_falsey
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested worker' do
      worker = Worker.create! valid_attributes
      expect do
        delete admin_worker_url(worker)
      end.to change(Worker, :count).by(-1)
    end

    it 'redirects to the workers list' do
      worker = Worker.create! valid_attributes
      delete admin_worker_url(worker)
      expect(response).to redirect_to(admin_workers_url)
    end
  end
end
