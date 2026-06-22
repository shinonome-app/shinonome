# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::CommandExecutor do
  describe '#execute' do
    let(:site) { create(:site) }

    def run(text)
      exec_command = instance_double(Shinonome::ExecCommand, command: text)
      Dir.mktmpdir do |output|
        Dir.mktmpdir do |upload|
          Shinonome::ExecCommand::CommandExecutor.new.execute(exec_command, output_dir: output, upload_dir: upload)
        end
      end
    end

    context '全コマンドが成功した場合' do
      it 'DB変更がコミットされる' do
        text = "SQL\tUPDATE sites SET name = 'changed by sql' WHERE id = #{site.id}"

        result = run(text)

        expect(result).to be_successful
        expect(site.reload.name).to eq 'changed by sql'
      end
    end

    context '途中のコマンドが失敗した場合' do
      it '結果は失敗になる' do
        text = [
          "SQL\tUPDATE sites SET name = 'changed by sql' WHERE id = #{site.id}",
          "SQL\tUPDATE no_such_table SET x = 1"
        ].join("\n")

        result = run(text)

        expect(result).not_to be_successful
      end

      it '成功していた先行コマンドのDB変更もロールバックされる' do
        text = [
          "SQL\tUPDATE sites SET name = 'changed by sql' WHERE id = #{site.id}",
          "SQL\tUPDATE no_such_table SET x = 1"
        ].join("\n")

        run(text)

        expect(site.reload.name).not_to eq 'changed by sql'
      end
    end
  end
end
