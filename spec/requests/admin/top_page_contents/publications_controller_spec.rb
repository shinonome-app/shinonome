# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TopPageContents::PublicationsController do
  describe 'POST /admin/top_page_content/publication' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'creates a published entry' do
      expect do
        post '/admin/top_page_content/publication', params: { editable_content: { value: '<p>published</p>' } }
      end.to change(EditableContent, :count).by(1)

      published = EditableContent.last
      expect(published.status).to eq('published')
      expect(published.published_at).not_to be_nil
      expect(published.value).to eq('<p>published</p>')
    end

    it 'creates a published entry with a natsuzora fragment' do
      expect do
        post '/admin/top_page_content/publication',
             params: { editable_content: { value: '<p>total: {[ works_count ]}</p>' } }
      end.to change(EditableContent, :count).by(1)
    end

    it 'rejects an invalid natsuzora fragment' do
      expect do
        post '/admin/top_page_content/publication', params: { editable_content: { value: '{[#if' } }
      end.not_to change(EditableContent, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('natsuzoraテンプレートとして不正です')
    end
  end
end
