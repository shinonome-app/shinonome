# frozen_string_literal: true

require 'rails_helper'

# RateLimitedCreate を include したコントローラの create は、IP ごとに 10 分間で 10 回まで
RSpec.describe 'Rate limits' do
  include ActiveSupport::Testing::TimeHelpers

  describe 'POST /receipts' do
    # 必須項目が足りないので保存されずに 422 になる
    let(:params) do
      {
        receipt_form: {
          worker_name: '青空太郎',
          sub_works_attributes: { '0' => { title: '吾輩は猫である', kana_type_id: 1, copyright_flag: 0 } }
        }
      }
    end

    it 'returns 429 after 10 requests within 10 minutes' do
      10.times do
        post receipts_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      post receipts_path, params: params
      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include('10分ほど待ってから')
    end

    it 'accepts requests again after the window' do
      10.times { post receipts_path, params: params }

      travel 11.minutes do
        post receipts_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it 'does not limit the confirmation page' do
      11.times do
        post receipts_previews_path, params: params
        expect(response).not_to have_http_status(:too_many_requests)
      end
    end

    it 'does not limit the back button on the confirmation page' do
      11.times do
        post receipts_edits_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /proofreads' do
    let(:author) { create(:person) }
    let(:work) { create(:work, :with_person, :teihon) }
    # 必須項目が足りないので保存されずに 422 になる
    let(:params) do
      {
        proofread_form: {
          worker_name: '校正花子',
          person_id: author.id,
          sub_works_attributes: { '0' => { work_id: work.id, work_copy: 0, work_print: 0, enabled: true } }
        }
      }
    end

    it 'returns 429 after 10 requests' do
      10.times do
        post proofreads_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      post proofreads_path, params: params
      expect(response).to have_http_status(:too_many_requests)
    end

    it 'does not limit the back button on the confirmation page' do
      11.times do
        post proofreads_edits_path, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST admin sign in' do
    let(:params) { { admin_user: { login: 'nobody', password: 'wrong' } } }

    it 'returns 429 after 10 attempts' do
      10.times do
        post admin_user_session_path, params: params
        expect(response).not_to have_http_status(:too_many_requests)
      end

      post admin_user_session_path, params: params
      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include('10分ほど待ってから')
    end
  end

  describe 'POST admin password reset' do
    let(:params) { { admin_user: { email: 'nobody@example.com' } } }

    it 'returns 429 after 10 requests' do
      10.times { post admin_user_password_path, params: params }

      post admin_user_password_path, params: params
      expect(response).to have_http_status(:too_many_requests)
    end
  end
end
