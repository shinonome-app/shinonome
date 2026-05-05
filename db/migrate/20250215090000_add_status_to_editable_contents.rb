# frozen_string_literal: true

class AddStatusToEditableContents < ActiveRecord::Migration[7.2]
  class EditableContent < ActiveRecord::Base
    self.table_name = 'editable_contents'
  end

  def up
    change_table :editable_contents, bulk: true do |t|
      t.string :status, null: false, default: 'draft'
      t.datetime :published_at
      t.index %i[area_name key status]
    end

    EditableContent.update_all(status: 'published', published_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
  end

  def down
    change_table :editable_contents, bulk: true do |t|
      t.remove_index column: %i[area_name key status]
      t.remove :published_at
      t.remove :status
    end
  end
end
