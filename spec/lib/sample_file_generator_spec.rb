# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SampleFileGenerator do
  describe '.text_convert' do
    let(:input_worker) { create(:worker) }
    let(:proofread_worker) { create(:worker) }

    context '原題がない場合' do
      let(:work) { create(:work, original_title: nil) }

      before do
        create(:work_worker, work:, worker: input_worker, worker_role_id: 1)
        create(:work_worker, work:, worker: proofread_worker, worker_role_id: 2)
      end

      it '正しいテキストが生成される' do
        text = SampleFileGenerator.new.text_convert(work)

        # rubocop:disable Layout/HeredocIndentation
        expect(text).to eq <<TEXT.gsub("\n", "\r\n")
#{work.title}
#{work.subtitle}


-------------------------------------------------------
【テキスト中に現れる記号について】

《》：ルビ
（例）青空文庫《あおぞらぶんこ》

［＃］：入力者注　主に外字の説明や、傍点の位置の指定
（例）［＃７字下げ］
-------------------------------------------------------

［＃７字下げ］一［＃「一」は中見出し］

　青空文庫《あおぞらぶんこ》形式のサンプルファイルです。

［＃７字下げ］二［＃「二」は中見出し］

　このファイルはサンプルとして自動的に生成されたものです。記述されている底本は存在しません。ご了承ください。



入力：#{work.inputer_text}
校正：#{work.proofreader_text}
#{work.updated_at_text}作成
青空文庫作成ファイル：
このファイルは、インターネットの図書館、青空文庫（https://www.aozora.gr.jp/）で作られました。入力、校正、制作にあたったのは、ボランティアの皆さんです。

TEXT
        # rubocop:enable Layout/HeredocIndentation
      end
    end

    context '原題がある場合' do
      let(:work) { create(:work, original_title: 'Awesome title ABC') }

      before do
        create(:work_worker, work:, worker: input_worker, worker_role_id: 1)
        create(:work_worker, work:, worker: proofread_worker, worker_role_id: 2)
      end

      it '正しいテキストが生成される' do
        text = SampleFileGenerator.new.text_convert(work)

        # rubocop:disable Layout/HeredocIndentation
        expect(text).to eq <<TEXT.gsub("\n", "\r\n")
#{work.title}
#{work.original_title}
#{work.subtitle}


-------------------------------------------------------
【テキスト中に現れる記号について】

《》：ルビ
（例）青空文庫《あおぞらぶんこ》

［＃］：入力者注　主に外字の説明や、傍点の位置の指定
（例）［＃７字下げ］
-------------------------------------------------------

［＃７字下げ］一［＃「一」は中見出し］

　青空文庫《あおぞらぶんこ》形式のサンプルファイルです。

［＃７字下げ］二［＃「二」は中見出し］

　このファイルはサンプルとして自動的に生成されたものです。記述されている底本は存在しません。ご了承ください。



入力：#{work.inputer_text}
校正：#{work.proofreader_text}
#{work.updated_at_text}作成
青空文庫作成ファイル：
このファイルは、インターネットの図書館、青空文庫（https://www.aozora.gr.jp/）で作られました。入力、校正、制作にあたったのは、ボランティアの皆さんです。

TEXT
        # rubocop:enable Layout/HeredocIndentation
      end
    end
  end

  describe '.generate_sample_html' do
    let(:input_worker) { create(:worker) }
    let(:proofread_worker) { create(:worker) }

    context '原題がない場合' do
      let(:work) { create(:work, original_title: nil) }
      let(:workfile) { create(:workfile, work:, filetype_id: 9, compresstype_id: 1) }

      before do
        create(:work_worker, work:, worker: input_worker, worker_role_id: 1)
        create(:work_worker, work:, worker: proofread_worker, worker_role_id: 2)
      end

      it '正しいHTMLが生成される' do
        SampleFileGenerator.new.generate_sample_html(workfile)
        expect(workfile.filename).to eq "#{workfile.work.id}_#{workfile.id}.html"

        text = workfile.workdata.download.force_encoding('utf-8')

        # rubocop:disable Layout/HeredocIndentation
        expect(text).to eq <<HTML
<html>
<head>
<title>#{work.title}</title>
</head>
<body>
<pre>
#{work.title}
#{work.subtitle}


-------------------------------------------------------
【テキスト中に現れる記号について】

《》：ルビ
（例）青空文庫《あおぞらぶんこ》

［＃］：入力者注　主に外字の説明や、傍点の位置の指定
（例）［＃７字下げ］
-------------------------------------------------------

［＃７字下げ］一［＃「一」は中見出し］

　青空文庫《あおぞらぶんこ》形式のサンプルファイルです。

［＃７字下げ］二［＃「二」は中見出し］

　このファイルはサンプルとして自動的に生成されたものです。記述されている底本は存在しません。ご了承ください。



入力：#{work.inputer_text}
校正：#{work.proofreader_text}
#{work.updated_at_text}作成
青空文庫作成ファイル：
このファイルは、インターネットの図書館、青空文庫（https://www.aozora.gr.jp/）で作られました。入力、校正、制作にあたったのは、ボランティアの皆さんです。

</pre>
</body>
</html>
HTML
        # rubocop:enable Layout/HeredocIndentation
      end
    end

    context '原題がある場合' do
      let(:work) { create(:work, original_title: 'Awesome title ABC') }
      let(:workfile) { create(:workfile, work:, filetype_id: 9, compresstype_id: 1) }

      before do
        create(:work_worker, work:, worker: input_worker, worker_role_id: 1)
        create(:work_worker, work:, worker: proofread_worker, worker_role_id: 2)
      end

      it '正しいHTMLが生成される' do
        SampleFileGenerator.new.generate_sample_html(workfile)
        text = workfile.workdata.download.force_encoding('utf-8')

        # rubocop:disable Layout/HeredocIndentation
        expect(text).to eq <<HTML
<html>
<head>
<title>#{work.title}</title>
</head>
<body>
<pre>
#{work.title}
#{work.original_title}
#{work.subtitle}


-------------------------------------------------------
【テキスト中に現れる記号について】

《》：ルビ
（例）青空文庫《あおぞらぶんこ》

［＃］：入力者注　主に外字の説明や、傍点の位置の指定
（例）［＃７字下げ］
-------------------------------------------------------

［＃７字下げ］一［＃「一」は中見出し］

　青空文庫《あおぞらぶんこ》形式のサンプルファイルです。

［＃７字下げ］二［＃「二」は中見出し］

　このファイルはサンプルとして自動的に生成されたものです。記述されている底本は存在しません。ご了承ください。



入力：#{work.inputer_text}
校正：#{work.proofreader_text}
#{work.updated_at_text}作成
青空文庫作成ファイル：
このファイルは、インターネットの図書館、青空文庫（https://www.aozora.gr.jp/）で作られました。入力、校正、制作にあたったのは、ボランティアの皆さんです。

</pre>
</body>
</html>
HTML
        # rubocop:enable Layout/HeredocIndentation
      end
    end
  end
end
