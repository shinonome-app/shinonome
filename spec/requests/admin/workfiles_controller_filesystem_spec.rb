# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::WorkfilesController do
  let(:work) { create(:work, :with_person) }
  let(:admin) { create(:user, email: 'admin@example.com', username: 'admin') }

  before do
    sign_in admin
  end

  describe 'Filesystem integration (basic)' do
    describe 'GET /admin/works/:work_id/workfiles/new' do
      it 'renders new workfile form' do
        get new_admin_work_workfile_path(work)
        expect(response).to be_successful
        expect(response.body).to include('作品ファイル')
      end
    end

    describe 'workfile creation with filesystem' do
      it 'provides correct path for filesystem storage' do
        workfile = create(:workfile, work: work, filename: 'integration_test.txt')

        expected_path = Rails.root.join('data/workfiles/cards', work.card_person_id.to_s, 'files', 'integration_test.txt')
        expect(workfile.filesystem.path).to eq(expected_path)
      end

      it 'filesystem responds to required methods' do
        workfile = create(:workfile, work: work)

        expect(workfile.filesystem).to respond_to(:path)
        expect(workfile.filesystem).to respond_to(:exists?)
        expect(workfile.filesystem).to respond_to(:save)
        expect(workfile.filesystem).to respond_to(:read)
        expect(workfile.filesystem).to respond_to(:delete)
        expect(workfile.filesystem).to respond_to(:size)
      end
    end

    describe 'controller filesystem integration compatibility' do
      it 'controller can access filesystem methods' do
        workfile = create(:workfile, work: work, filename: 'controller_test.txt')

        # Simulate what controller does
        expect { workfile.filesystem.path }.not_to raise_error
        expect { workfile.filesystem.exists? }.not_to raise_error
        expect(workfile.filesystem.exists?).to be false # file not created yet
      end
    end
  end
end
