# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::DeleteOriginalBook do
  let(:work) { create(:work) }

  before do
    create(:original_book,
           work: work,
           title: '底本タイトル',
           publisher: '底本出版社')
  end

  describe '#execute' do
    context '正しい引数を与えた場合' do
      it '底本を削除する' do
        command = Shinonome::ExecCommand::Command.new(['底本削除', work.id, '底本タイトル', '底本出版社'])

        expect do
          result = Shinonome::ExecCommand::Command::DeleteOriginalBook.new.execute(command)
          expect(result).to be_successful
        end.to change(OriginalBook, :count).by(-1)

        expect(OriginalBook.where(work: work, title: '底本タイトル', publisher: '底本出版社')).not_to exist
      end
    end

    context '存在しない作品IDの場合' do
      it 'FormatErrorが発生する' do
        command = Shinonome::ExecCommand::Command.new(['底本削除', 99999, '底本タイトル', '底本出版社'])

        expect do
          Shinonome::ExecCommand::Command::DeleteOriginalBook.new.execute(command)
        end.to raise_error(Shinonome::ExecCommand::FormatError, /対象の作品ID99999がありません/)
      end
    end

    context '該当する底本が存在しない場合' do
      it '成功するが何も削除されない' do
        command = Shinonome::ExecCommand::Command.new(['底本削除', work.id, '存在しないタイトル', '存在しない出版社'])

        expect do
          result = Shinonome::ExecCommand::Command::DeleteOriginalBook.new.execute(command)
          expect(result).to be_successful
        end.not_to change(OriginalBook, :count)
      end
    end

    context 'タイトルが一致するが出版社が異なる場合' do
      it '削除されない' do
        command = Shinonome::ExecCommand::Command.new(['底本削除', work.id, '底本タイトル', '異なる出版社'])

        expect do
          result = Shinonome::ExecCommand::Command::DeleteOriginalBook.new.execute(command)
          expect(result).to be_successful
        end.not_to change(OriginalBook, :count)

        expect(OriginalBook.where(work: work, title: '底本タイトル', publisher: '底本出版社')).to exist
      end
    end

    context '複数の底本が条件に一致する場合' do
      before do
        create(:original_book,
               work: work,
               title: '同じタイトル',
               publisher: '同じ出版社')
        create(:original_book,
               work: work,
               title: '同じタイトル',
               publisher: '同じ出版社')
      end

      it '条件に一致する全ての底本を削除する' do
        command = Shinonome::ExecCommand::Command.new(['底本削除', work.id, '同じタイトル', '同じ出版社'])

        expect do
          result = Shinonome::ExecCommand::Command::DeleteOriginalBook.new.execute(command)
          expect(result).to be_successful
        end.to change(OriginalBook, :count).by(-2)

        expect(OriginalBook.where(work: work, title: '同じタイトル', publisher: '同じ出版社')).not_to exist
      end
    end
  end
end
