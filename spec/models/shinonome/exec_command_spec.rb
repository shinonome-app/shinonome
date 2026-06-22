# frozen_string_literal: true

# == Schema Information
#
# Table name: exec_commands
#
#  id          :bigint           not null, primary key
#  command     :text
#  executed_at :datetime
#  result      :jsonb
#  separator   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand do
  describe '#execute' do
    let(:site) { create(:site) }
    let(:exec_command) do
      create(:exec_command, command: "SQL\tUPDATE sites SET name = 'changed by sql' WHERE id = #{site.id}")
    end

    context 'advisory lockを取得できない（他の実行が進行中の）場合' do
      before { allow(exec_command).to receive(:try_advisory_lock).and_return(false) }

      it 'falseを返す' do
        expect(exec_command.execute).to be false
      end

      it '実行中メッセージを保存する' do
        exec_command.execute
        expect(exec_command.error_messages).to include('他のユーザーがコマンドを実行中です。')
      end

      it 'コマンドを実行しない（DBは変更されない）' do
        exec_command.execute
        expect(site.reload.name).not_to eq 'changed by sql'
      end
    end

    context 'advisory lockを取得できた場合' do
      it 'コマンドを実行して成功する' do
        expect(exec_command.execute).to be true
        expect(site.reload.name).to eq 'changed by sql'
      end

      it '実行後にロックを解放する' do
        allow(exec_command).to receive(:release_advisory_lock).and_call_original
        exec_command.execute
        expect(exec_command).to have_received(:release_advisory_lock)
      end
    end
  end
end
