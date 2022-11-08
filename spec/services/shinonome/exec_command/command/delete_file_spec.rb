# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::DeleteFile do
  describe '.execute' do
    let!(:workfile) { create(:workfile, :xhtml) }

    attr_reader :tmpdir

    before do
      @tmpdir = Dir.mktmpdir

      workfile.update!(filename: workfile.generate_filename)
      file_path = File.join(tmpdir, workfile.filename)
      File.write(file_path, file_fixture('html/01jo.html').read)
    end

    after { FileUtils.remove_entry_secure tmpdir }

    context 'workfile_id以外の正しい引数を与えた場合' do
      it '成功のresultを返す' do
        result = Shinonome::ExecCommand::Command::DeleteFile.new.execute(
          workfile.work.id,
          'XHTMLファイル',
          '圧縮なし',
          nil,
          upload_dir: tmpdir
        )
        expect(result).to be_successful
      end

      it 'workfileが1つ減る' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            workfile.work.id,
            'XHTMLファイル',
            '圧縮なし',
            nil,
            upload_dir: tmpdir
          )
        end.to change(Workfile, :count).from(1).to(0)
      end
    end

    context 'workfile_idを与えた場合' do
      it '成功のresultを返す' do
        result = Shinonome::ExecCommand::Command::DeleteFile.new.execute(
          workfile.work.id,
          '',
          '',
          workfile.id,
          upload_dir: tmpdir
        )
        expect(result).to be_successful
      end

      it 'workfileが1つ減る' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            workfile.work.id,
            '',
            '',
            workfile.id,
            upload_dir: tmpdir
          )
        end.to change(Workfile, :count).from(1).to(0)
      end
    end

    context 'work_idが数値ではない場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            'abc',
            '',
            '',
            workfile.id,
            upload_dir: tmpdir
          )
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          'BookIDが数値ではありません。'
        )
      end
    end

    context 'work_idが存在しない場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            100000,
            '',
            '',
            workfile.id,
            upload_dir: tmpdir
          )
        end.to raise_error(Shinonome::ExecCommand::FormatError, '対象の作品ID100000がありません。')
      end
    end

    context 'workfile_idが存在しない場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            workfile.work.id,
            '',
            '',
            100000,
            upload_dir: tmpdir
          )
        end.to raise_error(Shinonome::ExecCommand::FormatError, '指定されたIDのファイルが見つかりません。')
      end
    end

    context 'filetypeが正しくない場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            workfile.work.id,
            'TEXTファイル',
            '',
            workfile.id,
            upload_dir: tmpdir
          )
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイル形式には"入力完了ファイル"か"テキストファイル(ルビあり)"か"テキストファイル(ルビなし)"か"HTMLファイル"か"エキスパンドブックファイル"か".workファイル"か"TTZファイル"か"PDFファイル"か"PalmDocファイル"か"XHTMLファイル"か"その他"を指定してください。')
      end
    end

    context 'filetypeの数値が正しくない場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            workfile.work.id,
            100,
            '',
            workfile.id,
            upload_dir: tmpdir
          )
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイル形式には"入力完了ファイル"か"テキストファイル(ルビあり)"か"テキストファイル(ルビなし)"か"HTMLファイル"か"エキスパンドブックファイル"か".workファイル"か"TTZファイル"か"PDFファイル"か"PalmDocファイル"か"XHTMLファイル"か"その他"を指定してください。')
      end
    end

    context 'compresstypeが正しくない場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            workfile.work.id,
            '',
            'TAR+GZ圧縮',
            workfile.id,
            upload_dir: tmpdir
          )
        end.to raise_error(Shinonome::ExecCommand::FormatError, '圧縮形式には"圧縮なし"か"ZIP圧縮"か"GZIP圧縮"か"LHA圧縮"か"SIT圧縮"を指定してください。')
      end
    end

    context 'work_idもcompresstype_idも空だった場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::DeleteFile.new.execute(
            workfile.work.id,
            'XHTMLファイル',
            '',
            '',
            upload_dir: tmpdir
          )
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイル形式と圧縮形式かファイルIDを指定してください。')
      end
    end
  end
end
