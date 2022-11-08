# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::AddSite do
  describe '.execute' do
    let(:work) { create(:work) }
    let(:site) { create(:site) }

    context '正しい引数を与えた場合' do
      it 'work_siteを含むResultを返す' do
        result = Shinonome::ExecCommand::Command::AddSite.new.execute(work.id, site.id)
        expect(result).to be_successful
        expect(result.command_result.work_id).to eq work.id
        expect(result.command_result.site_id).to eq site.id
      end
    end

    context 'site_idが数値ではない場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::AddSite.new.execute(work.id, 'サイトA')
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '関連サイトIDが数値ではありません。'
        )
      end
    end

    context '存在しないsiteを与えた場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::AddSite.new.execute(work.id, 1000000)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '対象の関連サイトID1000000がありません。'
        )
      end
    end
  end
end
