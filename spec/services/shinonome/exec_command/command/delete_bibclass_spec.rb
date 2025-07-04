# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::DeleteBibclass do
  describe '.execute' do
    let!(:bibclass) { create(:bibclass, num: '913') }

    context '正しい引数を与えた場合' do
      let(:command) { Shinonome::ExecCommand::Command.new(['分類削除', bibclass.work.id, 'NDC', '913']) }

      it 'bibclassを含むResultを返す' do
        result = Shinonome::ExecCommand::Command::DeleteBibclass.new.execute(command)
        expect(result).to be_successful
      end

      it 'bibclassが1つ減る' do
        expect { Shinonome::ExecCommand::Command::DeleteBibclass.new.execute(command) }.to change(Bibclass, :count).from(1).to(0)
      end
    end

    context 'work_idが数値ではない場合' do
      it '例外をあげる' do
        expect { Shinonome::ExecCommand::Command.new(%w[分類削除 invalid NDC 913]) }.to raise_error(Shinonome::ExecCommand::FormatError, 'BookIDが数値ではありません。')
      end
    end

    context 'work_idが存在しない場合' do
      let(:command) { Shinonome::ExecCommand::Command.new(['分類削除', 100000, 'NDC', '913']) }

      it '例外をあげる' do
        expect { Shinonome::ExecCommand::Command::DeleteBibclass.new.execute(command) }.to raise_error(Shinonome::ExecCommand::FormatError, '対象の作品ID100000がありません。')
      end
    end

    context 'numが異なる場合' do
      let(:command) { Shinonome::ExecCommand::Command.new(['分類削除', bibclass.work.id, 'NDC', '913 914']) }

      it '処理としては成功のResultを返す' do
        result = Shinonome::ExecCommand::Command::DeleteBibclass.new.execute(command)
        expect(result).to be_successful
      end

      it '削除はされないのでbibclassの数は変わらない' do
        expect { Shinonome::ExecCommand::Command::DeleteBibclass.new.execute(command) }.not_to change(Bibclass, :count)
      end
    end
  end
end
