# frozen_string_literal: true

# service module for folder
module DiskFolder
  def folder_name_for(filename)
    base_folder_name = if filename.include?('_')
                         filename.split('_').first
                       else
                         '_'
                       end
    first_part = format('%02d', base_folder_name[0, 2].to_i)
    [first_part, base_folder_name].join('/')
  end
end
