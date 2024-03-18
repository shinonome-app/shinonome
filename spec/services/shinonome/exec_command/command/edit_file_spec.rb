# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::EditFile do
  describe '.execute' do
    let(:work) { create(:work) }
    let(:workfile) { create(:workfile, :xhtml, work_id: work.id) }
    let(:args) do
      {
        work_id: work.id,
        filetype_name: 'XHTMLファイル',
        compresstype_name: '圧縮なし',
        url: '',
        create_date: '2022-10-11',
        update_date: '2022-10-15',
        revision_count: 5,
        file_encoding_name: 'ShiftJIS',
        charset_name: 'JIS X 0208',
        note: '備考123',
        filename: '',
        workfile_id: workfile.id
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
      it '正しく更新される' do
        file_path = File.join(tmpdir, '01jo2.html')
        File.write(file_path, file_fixture('html/01jo.html').read)
        args0 = args.merge(filename: '01jo2.html')

        row = args0.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        result = Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        expect(result).to be_successful
        remove_filename = result.command_result

        workfile = Workfile.find(args0[:workfile_id])
        expect(workfile.work_id).to eq work.id
        expect(workfile.filetype_id).to eq 9
        expect(workfile.compresstype_id).to eq 1
        expect(workfile.url).to be_nil
        expect(workfile.revision_count).to eq 5
        expect(workfile.file_encoding_id).to eq 1
        expect(workfile.charset_id).to eq 1
        expect(workfile.workfile_secret.memo).to eq '備考123'
        expect(workfile.filename).to eq "#{work.id}_#{workfile.id}.html"
        expect(File.basename(remove_filename)).to eq "#{work.id}_#{workfile.id}.html"
      end
    end

    context 'URLが与えられた場合' do
      it 'ファイル名はnil、URLは正しく更新される' do
        args0 = args.merge(url: 'https://example.com/sample/01jo.html')

        row = args0.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        result = Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        expect(result).to be_successful
        _remove_filename = result.command_result

        workfile = Workfile.find(args0[:workfile_id])
        expect(workfile.filetype_id).to eq 9
        expect(workfile.compresstype_id).to eq 1
        expect(workfile.url).to eq 'https://example.com/sample/01jo.html'
        expect(workfile.filename).to be_nil
      end
    end

    context 'URLもファイル名も与えられた場合' do
      it 'ファイル名はnil、URLは正しく更新される' do
        args0 = args.merge(url: 'https://example.com/sample/01jo.html', filename: 'foo.html')

        row = args0.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        result = Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        expect(result).to be_successful
        _remove_filename = result.command_result

        workfile = Workfile.find(args0[:workfile_id])
        expect(workfile.filetype_id).to eq 9
        expect(workfile.compresstype_id).to eq 1
        expect(workfile.url).to eq 'https://example.com/sample/01jo.html'
        expect(workfile.filename).to be_nil
      end
    end

    context 'URLもファイル名も与えられない場合' do
      it 'ファイル名は生成され、他も正しく更新される' do
        args0 = args

        row = args0.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        result = Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        expect(result).to be_successful
        _remove_filename = result.command_result

        workfile = Workfile.find(args0[:workfile_id])
        expect(workfile.filetype_id).to eq 9
        expect(workfile.compresstype_id).to eq 1
        expect(workfile.url).to be_nil
        expect(workfile.filename).to eq "#{work.id}_#{workfile.id}.html"
      end
    end

    context 'work_idが数値ではない場合' do
      it '例外をあげる' do
        args2 = args.merge(work_id: 'abc')

        row = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        expect do
          Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          'BookIDが数値ではありません。'
        )
      end
    end

    context 'work_idが存在しない場合' do
      it '例外をあげる' do
        args2 = args.merge(work_id: 100000)

        row = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        expect do
          Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, '対象の作品ID100000がありません。')
      end
    end

    context 'filetypeが正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(filetype_name: 'TEXTファイル')

        row = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        expect do
          Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイル形式には"入力完了ファイル"か"テキストファイル(ルビあり)"か"テキストファイル(ルビなし)"か"HTMLファイル"か"エキスパンドブックファイル"か".workファイル"か"TTZファイル"か"PDFファイル"か"PalmDocファイル"か"XHTMLファイル"か"EPUBファイル"か"その他"を指定してください。')
      end
    end

    context 'filetypeの数値が正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(filetype_name: 100)

        row = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        expect do
          Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイル形式には"入力完了ファイル"か"テキストファイル(ルビあり)"か"テキストファイル(ルビなし)"か"HTMLファイル"か"エキスパンドブックファイル"か".workファイル"か"TTZファイル"か"PDFファイル"か"PalmDocファイル"か"XHTMLファイル"か"EPUBファイル"か"その他"を指定してください。')
      end
    end

    context 'compresstypeが正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(compresstype_name: 'TAR+GZ圧縮')

        row = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        expect do
          Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, '圧縮形式には"圧縮なし"か"ZIP圧縮"か"GZIP圧縮"か"LHA圧縮"か"SIT圧縮"を指定してください。')
      end
    end

    context 'file_encodingが正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(file_encoding_name: 'UTF-16')

        row = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        expect do
          Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'ファイルエンコーディングには"ShiftJIS"か"JIS"か"EUC"か"UTF-8"か"その他"を指定してください。')
      end
    end

    context 'charsetが正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(charset_name: 'JIS X 0211')

        row = args2.values_at(:work_id, :filetype_name, :compresstype_name, :url, :create_date, :update_date,
                              :revision_count, :file_encoding_name, :charset_name, :note, :filename, :workfile_id)
        command = Shinonome::ExecCommand::Command.new(['ファイル更新', *row])

        expect do
          Shinonome::ExecCommand::Command::EditFile.new.execute(command, upload_dir: tmpdir)
        end.to raise_error(Shinonome::ExecCommand::FormatError, '文字集合には"JIS X 0208"か"JIS X 0213"か"Unicode"か"その他"を指定してください。')
      end
    end
  end
end
