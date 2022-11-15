# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetWorkSelect do
  describe '.execute' do
    before do
      create(:work)
      create(:work)
    end

    context '正しいカラムが与えられた場合' do
      let(:columns) { 'bookid,作品名,副題,状態,備考' }

      it '正しいCSVが生成される' do
        command = Shinonome::ExecCommand::Command.new(['bookselect', columns])

        Dir.mktmpdir do |dir|
          Shinonome::ExecCommand::Command::GetWorkSelect.new.execute(command, output_dir: dir)
          output_file = File.join(dir, 'bookselect.csv')
          File.open(output_file) do |f|
            line1 = f.gets
            expect(line1).to eq "#{Shinonome::ExecCommand::BOM}bookid,作品名,副題,状態,備考\r\n"

            ## line 2
            line2 = f.gets
            row2 = CSV.parse(line2)[0]
            work2 = Work.find(row2[0])

            expect(row2[0]).to eq work2.id.to_s
            expect(row2[1]).to eq work2.title
            expect(row2[2]).to eq work2.subtitle
            expect(row2[3]).to eq work2.work_status.name
            expect(row2[4]).to eq work2.note

            ## line 3
            line3 = f.gets
            row3 = CSV.parse(line3)[0]
            work3 = Work.find(row3[0])

            expect(row3[0]).to eq work3.id.to_s
            expect(row3[1]).to eq work3.title
            expect(row3[2]).to eq work3.subtitle
            expect(row3[3]).to eq work3.work_status.name
            expect(row3[4]).to eq work3.note
          end
        end
      end
    end

    context '先頭がbookidでない場合' do
      let(:columns) { '作品名,副題,状態,備考' }

      it 'エラーになる' do
        command = Shinonome::ExecCommand::Command.new(['bookselect', columns])

        Dir.mktmpdir do |dir|
          expect { Shinonome::ExecCommand::Command::GetWorkSelect.new.execute(command, output_dir: dir) }.to raise_error(Shinonome::ExecCommand::FormatError, 'BookIDは必須です。')
        end
      end
    end

    context '正しくない文字列が含まれている場合' do
      let(:columns) { 'bookid,作品名,count(*)' }

      it 'エラーになる' do
        command = Shinonome::ExecCommand::Command.new(['bookselect', columns])

        Dir.mktmpdir do |dir|
          expect { Shinonome::ExecCommand::Command::GetWorkSelect.new.execute(command, output_dir: dir) }.to raise_error(Shinonome::ExecCommand::FormatError, '正しいカラム名を指定してください。')
        end
      end
    end

    context 'カラムにない文字列が含まれている場合' do
      let(:columns) { 'bookid,作品名,偽カラム' }

      it 'エラーになる' do
        command = Shinonome::ExecCommand::Command.new(['bookselect', columns])

        Dir.mktmpdir do |dir|
          expect { Shinonome::ExecCommand::Command::GetWorkSelect.new.execute(command, output_dir: dir) }.to raise_error(Shinonome::ExecCommand::FormatError, '正しいカラム名を指定してください。')
        end
      end
    end
  end
end
