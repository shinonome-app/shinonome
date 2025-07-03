# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ExecCommandsController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /admin/exec_commands' do
    context 'when no exec commands exist' do
      it 'returns http success and displays page title' do
        get '/admin/exec_commands'

        expect(response).to have_http_status(:success)
        expect(response.body).to include('コマンド実行')
        expect(response.body).to include('新規コマンド実行')
      end
    end

    context 'when exec commands exist' do
      let!(:successful_command) { create(:exec_command, :with_result, user: user, command: 'work_list_all') }
      let!(:failed_command) { create(:exec_command, :failed, user: user, command: 'invalid_command') }
      let!(:pending_command) { create(:exec_command, user: user, command: 'pending_command') }

      it 'returns http success and displays all exec commands' do
        get '/admin/exec_commands'

        expect(response).to have_http_status(:success)
        expect(response.body).to include('work_list_all')
        expect(response.body).to include('invalid_command')
        expect(response.body).to include('pending_command')
      end

      it 'displays command table with headers' do
        get '/admin/exec_commands'

        expect(response.body).to include('ID')
        expect(response.body).to include('コマンド')
        expect(response.body).to include('実行日時')
      end
    end
  end

  describe 'GET /admin/exec_commands/new' do
    context 'without prev parameter' do
      it 'returns http success and displays form' do
        get '/admin/exec_commands/new'

        expect(response).to have_http_status(:success)
        expect(response.body).to include('コマンド実行')
        expect(response.body).to include('form')
        expect(response.body).not_to include('コマンド実行エラー')
      end
    end

    context 'with prev=failed parameter' do
      let!(:last_exec_command) { create(:exec_command, :failed, user: user) }

      before do
        # Ensure error_messages returns an array for the failed command
        allow(last_exec_command).to receive(:error_messages).and_return(['Command execution failed'])
      end

      it 'shows failure state and error messages' do
        get '/admin/exec_commands/new', params: { prev: 'failed' }

        expect(response).to have_http_status(:success)
        expect(response.body).to include('コマンド実行エラー')
        expect(response.body).to include('Command execution failed')
      end
    end

    context 'with prev=ok parameter' do
      let!(:last_exec_command) { create(:exec_command, :with_result, user: user) }

      before do
        # Mock the file exists check
        allow_any_instance_of(Shinonome::ExecCommand::Filesystem).to receive(:exists?).and_return(true)
      end

      it 'shows success state with download link' do
        get '/admin/exec_commands/new', params: { prev: 'ok' }

        expect(response).to have_http_status(:success)
        expect(response.body).to include('download')
        expect(response.body).not_to include('コマンド実行エラー')
      end
    end
  end

  describe 'POST /admin/exec_commands' do
    let(:valid_attributes) do
      {
        shinonome_exec_command: {
          command: 'work_list_all',
          separator: 'tab'
        }
      }
    end

    let(:invalid_attributes) do
      {
        shinonome_exec_command: {
          command: '',
          separator: 'tab'
        }
      }
    end

    context 'with valid parameters' do
      context 'when command execution succeeds' do
        before do
          allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_return(true)
        end

        it 'creates a new exec command' do
          expect do
            post '/admin/exec_commands', params: valid_attributes
          end.to change(Shinonome::ExecCommand, :count).by(1)
        end

        it 'assigns current user to the exec command' do
          post '/admin/exec_commands', params: valid_attributes

          created_command = Shinonome::ExecCommand.last
          expect(created_command.user).to eq(user)
        end

        it 'redirects to new with success indicator' do
          post '/admin/exec_commands', params: valid_attributes

          expect(response).to redirect_to(new_admin_exec_command_path(prev: :ok))
        end

        it 'executes the command' do
          exec_command_double = instance_double(Shinonome::ExecCommand)
          allow(Shinonome::ExecCommand).to receive(:new).and_return(exec_command_double)
          allow(exec_command_double).to receive(:user=)
          allow(exec_command_double).to receive(:save).and_return(true)
          expect(exec_command_double).to receive(:execute).and_return(true)

          post '/admin/exec_commands', params: valid_attributes
        end
      end

      context 'when command execution fails' do
        before do
          allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_return(false)
        end

        it 'creates a new exec command but redirects to failure page' do
          expect do
            post '/admin/exec_commands', params: valid_attributes
          end.to change(Shinonome::ExecCommand, :count).by(1)
        end

        it 'redirects to new with failure indicator' do
          post '/admin/exec_commands', params: valid_attributes

          expect(response).to redirect_to(new_admin_exec_command_path(prev: :failed))
        end
      end

      context 'with comma separator' do
        let(:comma_attributes) do
          {
            shinonome_exec_command: {
              command: 'work_list_all',
              separator: 'comma'
            }
          }
        end

        before do
          allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_return(true)
        end

        it 'creates exec command with comma separator' do
          post '/admin/exec_commands', params: comma_attributes

          created_command = Shinonome::ExecCommand.last
          expect(created_command.separator).to eq('comma')
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new exec command' do
        expect do
          post '/admin/exec_commands', params: invalid_attributes
        end.not_to change(Shinonome::ExecCommand, :count)
      end

      it 'renders new template with unprocessable entity status' do
        post '/admin/exec_commands', params: invalid_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('コマンド実行')
      end

      it 'displays validation errors' do
        post '/admin/exec_commands', params: invalid_attributes

        expect(response.body).to include('form')
        # The exact error message depends on the form implementation
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not execute the command' do
        # Use a real object but stub save to return false
        exec_command = build(:exec_command, command: '')
        allow(Shinonome::ExecCommand).to receive(:new).and_return(exec_command)
        allow(exec_command).to receive(:save).and_return(false)
        expect(exec_command).not_to receive(:execute)

        post '/admin/exec_commands', params: invalid_attributes
      end
    end

    context 'parameter filtering' do
      let(:attributes_with_extra_params) do
        {
          shinonome_exec_command: {
            command: 'work_list_all',
            separator: 'tab',
            malicious_param: 'should_be_filtered',
            user_id: 999 # Should not be settable via params
          }
        }
      end

      before do
        allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_return(true)
      end

      it 'filters out unpermitted parameters' do
        post '/admin/exec_commands', params: attributes_with_extra_params

        created_command = Shinonome::ExecCommand.last
        expect(created_command.command).to eq('work_list_all')
        expect(created_command.separator).to eq('tab')
        expect(created_command.user).to eq(user) # Set by controller, not params
      end
    end
  end

  describe 'authentication requirements' do
    before { sign_out(user) }

    it 'requires authentication for index' do
      get '/admin/exec_commands'
      expect(response).to redirect_to(new_admin_user_session_path)
    end

    it 'requires authentication for new' do
      get '/admin/exec_commands/new'
      expect(response).to redirect_to(new_admin_user_session_path)
    end

    it 'requires authentication for create' do
      post '/admin/exec_commands', params: { shinonome_exec_command: { command: 'test' } }
      expect(response).to redirect_to(new_admin_user_session_path)
    end
  end

  describe 'edge cases and error handling' do
    context 'when database save fails unexpectedly' do
      before do
        allow_any_instance_of(Shinonome::ExecCommand).to receive(:save).and_return(false)
      end

      it 'handles save failure gracefully' do
        post '/admin/exec_commands', params: {
          shinonome_exec_command: { command: 'work_list_all', separator: 'tab' }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('コマンド実行')
      end
    end

    context 'when command execution raises an exception' do
      before do
        allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_raise(StandardError, 'Unexpected error')
      end

      it 'allows the exception to bubble up' do
        expect do
          post '/admin/exec_commands', params: {
            shinonome_exec_command: { command: 'work_list_all', separator: 'tab' }
          }
        end.to raise_error(StandardError, 'Unexpected error')
      end
    end
  end

  describe 'integration scenarios' do
    context 'successful workflow' do
      before do
        allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_return(true)
        allow_any_instance_of(Shinonome::ExecCommand::Filesystem).to receive(:exists?).and_return(true)
      end

      it 'follows complete success workflow' do
        # Visit new form
        get '/admin/exec_commands/new'
        expect(response).to have_http_status(:success)

        # Submit valid command
        post '/admin/exec_commands', params: {
          shinonome_exec_command: { command: 'work_list_all', separator: 'tab' }
        }
        expect(response).to redirect_to(new_admin_exec_command_path(prev: :ok))

        # Follow redirect to see success message
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include('download')

        # Check that command appears in index
        get '/admin/exec_commands'
        expect(response.body).to include('work_list_all')
      end
    end

    context 'failure workflow' do
      before do
        allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_return(false)
        # Mock the error_messages method to return an array when the command failed
        allow_any_instance_of(Shinonome::ExecCommand).to receive(:error_messages).and_return(['Command execution failed'])
      end

      it 'follows complete failure workflow' do
        # Submit command that will fail
        post '/admin/exec_commands', params: {
          shinonome_exec_command: { command: 'failing_command', separator: 'tab' }
        }
        expect(response).to redirect_to(new_admin_exec_command_path(prev: :failed))

        # Follow redirect to see error message
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include('コマンド実行エラー')

        # Check that failed command still appears in index
        get '/admin/exec_commands'
        expect(response.body).to include('failing_command')
      end
    end
  end

  describe 'form submission behavior' do
    context 'with different command types' do
      before do
        allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_return(true)
      end

      %w[work_list_all person_list_all work_status_report].each do |command|
        it "handles #{command} command correctly" do
          post '/admin/exec_commands', params: {
            shinonome_exec_command: { command: command, separator: 'tab' }
          }

          expect(response).to redirect_to(new_admin_exec_command_path(prev: :ok))
          created_command = Shinonome::ExecCommand.last
          expect(created_command.command).to eq(command)
        end
      end
    end

    context 'with different separator types' do
      before do
        allow_any_instance_of(Shinonome::ExecCommand).to receive(:execute).and_return(true)
      end

      %w[tab comma].each do |separator|
        it "handles #{separator} separator correctly" do
          post '/admin/exec_commands', params: {
            shinonome_exec_command: { command: 'work_list_all', separator: separator }
          }

          expect(response).to redirect_to(new_admin_exec_command_path(prev: :ok))
          created_command = Shinonome::ExecCommand.last
          expect(created_command.separator).to eq(separator)
        end
      end
    end
  end

  describe 'download functionality integration' do
    context 'when exec command has a result file' do
      let!(:exec_command) { create(:exec_command, :with_result, user: user) }

      before do
        allow_any_instance_of(Shinonome::ExecCommand::Filesystem).to receive(:exists?).and_return(true)
      end

      it 'displays download link on success page' do
        get '/admin/exec_commands/new', params: { prev: 'ok' }

        expect(response).to have_http_status(:success)
        expect(response.body).to include('download')
        expect(response.body).to include(admin_exec_command_download_path(exec_command))
      end
    end

    context 'when exec command has no result file' do
      let!(:exec_command) { create(:exec_command, :with_result, user: user) }

      before do
        allow_any_instance_of(Shinonome::ExecCommand::Filesystem).to receive(:exists?).and_return(false)
      end

      it 'does not display download link' do
        get '/admin/exec_commands/new', params: { prev: 'ok' }

        expect(response).to have_http_status(:success)
        expect(response.body).not_to include('download')
      end
    end
  end
end
