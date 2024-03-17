# frozen_string_literal: true

require 'active_storage/service/disk_service'

module ActiveStorage
  class Service
    # An extension of the ActiveStorage::Service::DiskService, designed to enhance file management
    # by organizing files into a nested folder structure based on their filenames instead of keys.
    #
    # ex:
    #  9_ruby_21.zip -> 09/9/9_ruby_21.zip
    #  3157_ruby_5251.zip -> 31/3157/3157_ruby_5251.zip
    class FilenameBasedDiskService < ::ActiveStorage::Service::DiskService
      def path_for(key)
        blob = ActiveStorage::Blob.find_by(key:)
        filename = blob.filename.to_s
        File.join(root, folder_for_by_filename(filename), filename)
      end

      private

      def folder_for_by_filename(filename)
        base_folder_name = if filename.include?('_')
                             filename.split('_').first
                           else
                             '_'
                           end
        first_part = format('%02d', base_folder_name[0, 2].to_i)
        [first_part, base_folder_name].join('/')
      end
    end
  end
end
