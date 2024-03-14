# frozen_string_literal: true

class RemoveSecretColumns < ActiveRecord::Migration[7.1]
  def change
    reversible do |direction|
      change_table :sites, bulk: true do |t|
        direction.up do
          t.remove :email
          t.remove :owner_name
          t.remove :note
        end

        direction.down do
          t.text :email
          t.text :owner_name
          t.text :note
        end
      end

      change_table :original_books, bulk: true do |t|
        direction.up do
          t.remove :note
        end

        direction.down do
          t.text :note
        end
      end

      change_table :people, bulk: true do |t|
        direction.up do
          t.remove :note_user_id
          t.remove :note
        end

        direction.down do
          t.bigint :note_user_id
          t.text :note
        end
      end

      change_table :works, bulk: true do |t|
        direction.up do
          t.remove :orig_text
        end

        direction.down do
          t.text :orig_text
        end
      end

      change_table :workfiles, bulk: true do |t|
        direction.up do
          t.remove :opened_on
          t.remove :user_id
          t.remove :note
        end

        direction.down do
          t.date :opened_on
          t.bigint :user_id
          t.text :note
        end
      end
    end
  end
end
