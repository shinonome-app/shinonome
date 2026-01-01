# frozen_string_literal: true

class AddStatusToEditableContents < ActiveRecord::Migration[7.2]
  class EditableContent < ActiveRecord::Base
    self.table_name = 'editable_contents'
  end

  def up
    add_column :editable_contents, :status, :string, null: false, default: 'draft'
    add_column :editable_contents, :published_at, :datetime
    add_index :editable_contents, %i[area_name key status]

    EditableContent.update_all(status: 'published', published_at: Time.zone.now)
  end

  def down
    remove_index :editable_contents, column: %i[area_name key status]
    remove_column :editable_contents, :published_at
    remove_column :editable_contents, :status
  end
end
