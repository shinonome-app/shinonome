# frozen_string_literal: true

require 'rails_helper'

# Helper module for test
module FilenameBasedDiskServiceHelper
  # from ActiveStorage::BlobTest in Rails
  def create_blob(key: nil, data: 'Hello world!', filename: 'hello.txt', content_type: 'text/plain', identify: true, service_name: nil, record: nil) # rubocop:disable Metrics/ParameterLists
    ActiveStorage::Blob.create_and_upload!(
      key:,
      io: StringIO.new(data),
      filename:,
      content_type:,
      identify:,
      service_name:,
      record:
    )
  end

  def relative_path(src, dest)
    Pathname.new(src).relative_path_from(dest).to_s
  end
end

RSpec.describe ActiveStorage::Service::FilenameBasedDiskService do
  include FilenameBasedDiskServiceHelper

  let!(:service) { ActiveStorage::Blob.services.fetch(:local_test) }

  describe '.name' do
    it 'returns valid service name' do
      expect(service.name).to eq :local_test
    end
  end

  describe '#path_for' do
    it 'short name' do
      blob = create_blob(
        filename: '1_ruby_2.zip',
        data: 'Something else entirely!',
        service_name: :local_test,
        content_type: 'application/zip'
      )

      blob_path = service.path_for(blob.key)
      expect(relative_path(blob_path, service.root)).to eq '01/1/1_ruby_2.zip'
    ensure
      service.delete(blob.key)
    end

    it 'long name' do
      blob = create_blob(
        filename: '56789_ruby_12345.zip',
        data: 'Something else entirely!',
        service_name: :local_test,
        content_type: 'application/zip'
      )

      blob_path = service.path_for(blob.key)
      expect(relative_path(blob_path, service.root)).to eq '56/56789/56789_ruby_12345.zip'
    ensure
      service.delete(blob.key)
    end

    it 'invalid name' do
      blob = create_blob(
        filename: 'ruby12345.zip',
        data: 'Something else entirely!',
        service_name: :local_test,
        content_type: 'application/zip'
      )

      blob_path = service.path_for(blob.key)
      expect(relative_path(blob_path, service.root)).to eq '00/_/ruby12345.zip'
    ensure
      service.delete(blob.key)
    end
  end
end
