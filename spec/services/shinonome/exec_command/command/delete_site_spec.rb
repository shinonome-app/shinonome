# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::DeleteSite do
  let(:work) { create(:work) }
  let(:site) { create(:site) }

  before do
    create(:work_site, work: work, site: site)
  end

  describe '#execute' do
    context '正しい引数を与えた場合' do
      it 'work_siteを削除する' do
        command = Shinonome::ExecCommand::Command.new(['サイト削除', work.id, site.id])

        expect do
          result = Shinonome::ExecCommand::Command::DeleteSite.new.execute(command)
          expect(result).to be_successful
        end.to change(WorkSite, :count).by(-1)

        expect(WorkSite.where(work: work, site: site)).not_to exist
      end
    end

    context '存在しない作品IDの場合' do
      it 'FormatErrorが発生する' do
        command = Shinonome::ExecCommand::Command.new(['サイト削除', 99999, site.id])

        expect do
          Shinonome::ExecCommand::Command::DeleteSite.new.execute(command)
        end.to raise_error(Shinonome::ExecCommand::FormatError, /対象の作品ID99999がありません/)
      end
    end

    context '存在しないサイトIDの場合' do
      it 'FormatErrorが発生する' do
        command = Shinonome::ExecCommand::Command.new(['サイト削除', work.id, 99999])

        expect do
          Shinonome::ExecCommand::Command::DeleteSite.new.execute(command)
        end.to raise_error(Shinonome::ExecCommand::FormatError, /対象の関連サイトID99999がありません/)
      end
    end

    context 'site_idが数値ではない場合' do
      it 'FormatErrorが発生する' do
        command = Shinonome::ExecCommand::Command.new(['サイト削除', work.id, 'abc'])

        expect do
          Shinonome::ExecCommand::Command::DeleteSite.new.execute(command)
        end.to raise_error(Shinonome::ExecCommand::FormatError, /関連サイトIDが数値ではありません/)
      end
    end

    context '該当するwork_siteが存在しない場合' do
      it '成功するが何も削除されない' do
        other_work = create(:work)
        command = Shinonome::ExecCommand::Command.new(['サイト削除', other_work.id, site.id])

        expect do
          result = Shinonome::ExecCommand::Command::DeleteSite.new.execute(command)
          expect(result).to be_successful
        end.not_to change(WorkSite, :count)

        # 元のwork_siteは残っている
        expect(WorkSite.where(work: work, site: site)).to exist
      end
    end
  end
end
