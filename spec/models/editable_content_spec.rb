# frozen_string_literal: true

# == Schema Information
#
# Table name: editable_contents
#
#  id           :bigint           not null, primary key
#  area_name    :string
#  key          :string
#  published_at :datetime
#  status       :string           default("draft"), not null
#  value        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_editable_contents_on_area_name_and_key             (area_name,key)
#  index_editable_contents_on_area_name_and_key_and_status  (area_name,key,status)
#
require 'rails_helper'

RSpec.describe EditableContent do
  let!(:content1) { create(:editable_content, area_name: 'info', key: 'main', created_at: 1.day.ago) }

  before do
    create(:editable_content, area_name: 'info', key: 'main', created_at: 2.days.ago)
    create(:editable_content, area_name: 'info', key: 'footer', created_at: 3.days.ago)
    create(:editable_content, area_name: 'other', key: 'main', created_at: 4.days.ago)
  end

  describe '.latest_for' do
    it 'returns the most recent content for the specified area_name and key' do
      latest_content = EditableContent.latest_for('info', 'main')
      expect(latest_content).to eq(content1)
    end

    it 'returns nil if no content matches the specified area_name and key' do
      latest_content = EditableContent.latest_for('nonexistent', 'key')
      expect(latest_content).to be_nil
    end
  end

  describe '.latest_published_for' do
    it 'returns the most recent published content for the specified area_name and key' do
      published = create(:editable_content, area_name: 'info', key: 'main', status: 'published', published_at: 3.days.ago)
      latest_published = create(:editable_content, area_name: 'info', key: 'main', status: 'published', published_at: 1.day.ago)

      expect(EditableContent.latest_published_for('info', 'main')).to eq(latest_published)
      expect(EditableContent.latest_published_for('info', 'main')).not_to eq(published)
    end
  end

  describe '.latest_draft_for' do
    it 'returns the most recent draft content for the specified area_name and key' do
      latest_draft = create(:editable_content, area_name: 'info', key: 'main', status: 'draft', created_at: Time.zone.now)
      create(:editable_content, area_name: 'info', key: 'main', status: 'draft', created_at: 2.days.ago)

      expect(EditableContent.latest_draft_for('info', 'main')).to eq(latest_draft)
    end
  end

  describe 'validations' do
    it 'is invalid without area_name' do
      content = build(:editable_content, area_name: nil)
      expect(content).not_to be_valid
    end

    it 'is invalid without key' do
      content = build(:editable_content, key: nil)
      expect(content).not_to be_valid
    end

    it 'is invalid without status' do
      content = build(:editable_content, status: nil)
      expect(content).not_to be_valid
    end
  end

  describe 'published_at' do
    it 'sets published_at when publishing' do
      content = create(:editable_content, status: 'published', published_at: nil)
      expect(content.published_at).not_to be_nil
    end

    it 'does not set published_at when draft' do
      content = create(:editable_content, status: 'draft', published_at: nil)
      expect(content.published_at).to be_nil
    end
  end
end
