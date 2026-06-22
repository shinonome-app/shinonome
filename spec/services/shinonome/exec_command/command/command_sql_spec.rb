# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::CommandSql do
  describe '#execute' do
    let(:site) { create(:site) }

    context '正しいSQLを与えた場合' do
      it 'SQLが実行される' do
        command = Shinonome::ExecCommand::Command.new(['SQL', "UPDATE sites SET name = 'updated by sql' WHERE id = #{site.id}"])

        result = Shinonome::ExecCommand::Command::CommandSql.new.execute(command)

        expect(result).to be_successful
        expect(site.reload.name).to eq 'updated by sql'
      end
    end

    context 'SQLが空の場合' do
      it 'FormatErrorをあげる' do
        command = Shinonome::ExecCommand::Command.new(['SQL', ''])

        expect do
          Shinonome::ExecCommand::Command::CommandSql.new.execute(command)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'SQLを指定してください。')
      end
    end

    context '不正なSQLを与えた場合' do
      it '例外をあげる' do
        command = Shinonome::ExecCommand::Command.new(['SQL', 'UPDATE no_such_table SET x = 1'])

        expect do
          Shinonome::ExecCommand::Command::CommandSql.new.execute(command)
        end.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end
end
