# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::AddFile do
  describe '.execute' do
    let(:work) { create(:work) }
    let(:args) do
      {
        work_id: work.id,
        filetype_name: 'HTMLファイル',
        compresstype_name: '圧縮なし',
        url: '',
        create_date: '2022-10-11',
        update_date: '2022-10-15',
        revision_count: 2,
        file_encoding_name: 'ShiftJIS',
        charset_name: 'JIS X 0208',
        note: '備考123',
        filename: ''
      }
    end

    attr_reader :tmpdir

    before do
      @tmpdir = Dir.mktmpdir
    end

    after do
      FileUtils.remove_entry_secure tmpdir
    end

    context '正しい引数を与えた場合' do
      it 'workfileを含むResultを返す' do
        file_path = File.join(tmpdir, '01jo.html')
        File.write(file_path, file_fixture('html/01jo.html').read)
        args0 = args.merge(filename: '01jo.html')

        rows = args0.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        result = Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        expect(result).to be_successful
        workfile = result.command_result
        expect(workfile.work_id).to eq work.id
        expect(workfile.filetype_id).to eq 3
        expect(workfile.compresstype_id).to eq 1
        expect(workfile.charset_id).to eq 1
        expect(workfile.url).to eq ''
        expect(workfile.filename).to eq "#{work.id}_#{workfile.id}.html"
      end
    end

    context 'URLで正しい引数を与えた場合' do
      it 'workfileを含むResultを返す' do
        args0 = args.merge(url: 'https://example.com/sample/01jo.html')

        rows = args0.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        result = Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        expect(result).to be_successful
        workfile = result.command_result
        expect(workfile.work_id).to eq work.id
        expect(workfile.filetype_id).to eq 3
        expect(workfile.compresstype_id).to eq 1
        expect(workfile.charset_id).to eq 1
        expect(workfile.url).to eq 'https://example.com/sample/01jo.html'
        expect(workfile.filename).to be_nil
      end
    end

    context 'work_idが数値ではない場合' do
      it '例外をあげる' do
        args2 = args.merge(work_id: 'abc')
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          'BookIDが数値ではありません。'
        )
      end
    end

    context 'work_idが存在しない場合' do
      it '例外をあげる' do
        args2 = args.merge(work_id: 100000)
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, '対象の作品ID100000がありません。')
      end
    end

    context 'filetypeが正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(filetype_name: 'TEXTファイル')
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイル形式には"入力完了ファイル"か"テキストファイル(ルビあり)"か"テキストファイル(ルビなし)"か"HTMLファイル"か"エキスパンドブックファイル"か".workファイル"か"TTZファイル"か"PDFファイル"か"PalmDocファイル"か"XHTMLファイル"か"EPUBファイル"か"その他"を指定してください。')
      end
    end

    context 'filetypeの数値が正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(filetype_name: 100)
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイル形式には"入力完了ファイル"か"テキストファイル(ルビあり)"か"テキストファイル(ルビなし)"か"HTMLファイル"か"エキスパンドブックファイル"か".workファイル"か"TTZファイル"か"PDFファイル"か"PalmDocファイル"か"XHTMLファイル"か"EPUBファイル"か"その他"を指定してください。')
      end
    end

    context 'compresstypeが正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(compresstype_name: 'TAR+GZ圧縮')
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, '圧縮形式には"圧縮なし"か"ZIP圧縮"か"GZIP圧縮"か"LHA圧縮"か"SIT圧縮"を指定してください。')
      end
    end

    context 'file_encodingが正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(file_encoding_name: 'UTF-16')
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイルエンコーディングには"ShiftJIS"か"JIS"か"EUC"か"UTF-8"か"その他"を指定してください。')
      end
    end

    context 'charsetが正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(charset_name: 'JIS X 0211')
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, '文字集合には"JIS X 0208"か"JIS X 0213"か"Unicode"か"その他"を指定してください。')
      end
    end

    context 'URLもfilenameもない場合' do
      it '例外をあげる' do
        args2 = args.merge(url: '', filename: '')
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイルかURLを指定してください。')
      end
    end

    context 'filenameが違っている場合' do
      it '例外をあげる' do
        args2 = args.merge(filename: 'foobar.html')
        rows = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                               :revision_count, :file_encoding_name, :charset_name, :note, :filename)
        command = Shinonome::ExecCommand::Command.new(['ファイル追加', *rows])

        expect do
          Shinonome::ExecCommand::Command::AddFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイルがアップロードされていません。')
      end
    end
  end
end
