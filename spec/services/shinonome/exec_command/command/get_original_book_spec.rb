# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetOriginalBook do
  describe '.execute' do
    before do
      create(:original_book, booktype_id: 1)
      create(:original_book, booktype_id: 2)
    end

    it '正しいCSVが生成される' do
      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetOriginalBook.new.execute(output_dir: dir)
        output_file = File.join(dir, 'source.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}bookid,書籍名,出版社名,初版発行年,入力に使用した版,校正に使用した版,種別フラグ,備考\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          original_book2 = OriginalBook.where(work_id: row2[0]).first

          expect(row2[1]).to eq original_book2.title
          expect(row2[2]).to eq original_book2.publisher
          expect(row2[3]).to eq original_book2.first_pubdate
          expect(row2[4]).to eq original_book2.input_edition
          expect(row2[5]).to eq original_book2.proof_edition
          expect(row2[6]).to eq '底本'
          expect(row2[7]).to eq original_book2.note

          ## line 3
          line3 = f.gets
          row3 = CSV.parse(line3)[0]
          original_book3 = OriginalBook.where(work_id: row3[0]).first

          expect(row3[1]).to eq original_book3.title
          expect(row3[2]).to eq original_book3.publisher
          expect(row3[3]).to eq original_book3.first_pubdate
          expect(row3[4]).to eq original_book3.input_edition
          expect(row3[5]).to eq original_book3.proof_edition
          expect(row3[6]).to eq '底本の親本'
          expect(row3[7]).to eq original_book3.note
        end
      end
    end
  end
end
