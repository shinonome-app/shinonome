# frozen_string_literal: true

class RenameWorkfileToWorkfileIdInProofreads < ActiveRecord::Migration[7.2]
  def change
    rename_column :proofreads, :workfile, :workfile_id
    rename_column :workfiles, :registrated_on, :registered_on
  end
end
