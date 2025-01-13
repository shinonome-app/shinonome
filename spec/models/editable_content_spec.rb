# frozen_string_literal: true

# == Schema Information
#
# Table name: editable_contents
#
#  id         :bigint           not null, primary key
#  area_name  :string
#  key        :string
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_editable_contents_on_area_name_and_key  (area_name,key)
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
end
