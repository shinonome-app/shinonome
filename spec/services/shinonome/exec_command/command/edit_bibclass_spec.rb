# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::EditBibclass do
  describe '.execute' do
    let(:work) { create(:work) }

    context '正しい引数を与えた場合' do
      before do
        create(:bibclass, work_id: work.id, name: 'NDC', num: '913 914', note: '備考修正前')
      end

      it 'bibclassを含むResultを返す' do
        work_id = work.id
        result = Shinonome::ExecCommand::Command::EditBibclass.new.execute(work_id, 'NDC', '913 914', '備考ABC')

        expect(result).to be_successful
        bibclasses = result.command_result
        expect(bibclasses.count).to eq 1
        bibclass = bibclasses.first
        expect(bibclass.work_id).to eq work_id
        expect(bibclass.name).to eq 'NDC'
        expect(bibclass.num).to eq '913 914'
        expect(bibclass.note).to eq '備考ABC'
      end
    end

    context '引数numが異なっていた場合' do
      before do
        create(:bibclass, work_id: work.id, name: 'NDC', num: '913', note: '備考修正前')
      end

      it 'Resultの件数は0件で、更新されない' do
        work_id = work.id
        result = Shinonome::ExecCommand::Command::EditBibclass.new.execute(work_id, 'NDC', '913 914', '備考ABC')

        expect(result).to be_successful
        bibclasses = result.command_result
        expect(bibclasses.count).to eq 0

        bibclass = Bibclass.find_by(work_id: work_id, name: 'NDC', num: '913')
        expect(bibclass.note).to eq '備考修正前'
      end
    end

    context 'work_idが数値ではない場合' do
      it '例外をあげる' do
        expect { Shinonome::ExecCommand::Command::EditBibclass.new.execute('invalid', 'NDC', '913 914', '備考ABC') }.to raise_error(Shinonome::ExecCommand::FormatError, 'BookIDが数値ではありません。')
      end
    end

    context 'work_idが存在しない場合' do
      it '例外をあげる' do
        expect { Shinonome::ExecCommand::Command::EditBibclass.new.execute(100000, 'NDC', '913 914', '備考ABC') }.to raise_error(Shinonome::ExecCommand::FormatError, '対象の作品ID100000がありません。')
      end
    end
  end
end
