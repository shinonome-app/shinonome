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
  end
end
