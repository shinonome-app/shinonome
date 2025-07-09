# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#safe_html' do
    context '空の入力の場合' do
      it 'nilの場合は空文字列を返すこと' do
        expect(helper.safe_html(nil)).to eq('')
      end

      it '空文字列の場合は空文字列を返すこと' do
        expect(helper.safe_html('')).to eq('')
      end

      it '空白文字のみの場合は空文字列を返すこと' do
        expect(helper.safe_html('   ')).to eq('')
      end
    end

    context '安全なHTMLタグの場合' do
      it '許可されたタグは保持されること' do
        html = '<p>段落</p><strong>強調</strong><em>斜体</em>'
        expect(helper.safe_html(html)).to eq('<p>段落</p><strong>強調</strong><em>斜体</em>')
      end

      it '見出しタグが保持されること' do
        html = '<h1>見出し1</h1><h2>見出し2</h2><h3>見出し3</h3>'
        expect(helper.safe_html(html)).to eq('<h1>見出し1</h1><h2>見出し2</h2><h3>見出し3</h3>')
      end

      it 'リンクタグと属性が保持されること' do
        html = '<a href="https://example.com" title="リンク">リンクテキスト</a>'
        expect(helper.safe_html(html)).to eq('<a href="https://example.com" title="リンク">リンクテキスト</a>')
      end

      it '画像タグと属性が保持されること' do
        html = '<img src="/image.jpg" alt="画像" width="100" height="50">'
        expect(helper.safe_html(html)).to eq('<img src="/image.jpg" alt="画像" width="100" height="50">')
      end

      it 'リストタグが保持されること' do
        html = '<ul><li>項目1</li><li>項目2</li></ul><ol><li>番号1</li><li>番号2</li></ol>'
        expect(helper.safe_html(html)).to eq('<ul><li>項目1</li><li>項目2</li></ul><ol><li>番号1</li><li>番号2</li></ol>')
      end

      it 'テーブルタグが保持されること' do
        html = '<table><thead><tr><th>見出し</th></tr></thead><tbody><tr><td>データ</td></tr></tbody></table>'
        expect(helper.safe_html(html)).to eq('<table><thead><tr><th>見出し</th></tr></thead><tbody><tr><td>データ</td></tr></tbody></table>')
      end

      it '改行タグが保持されること' do
        html = '行1<br>行2<br>行3'
        expect(helper.safe_html(html)).to eq('行1<br>行2<br>行3')
      end
    end

    context '危険なHTMLの場合' do
      it 'scriptタグが除去されること' do
        html = '<p>テキスト</p><script>alert("XSS")</script>'
        expect(helper.safe_html(html)).to eq('<p>テキスト</p>alert("XSS")')
      end

      it 'onclickなどのイベントハンドラが除去されること' do
        html = '<div onclick="alert(\'XSS\')">クリック</div>'
        expect(helper.safe_html(html)).to eq('<div>クリック</div>')
      end

      it 'styleタグが除去されること' do
        html = '<style>body { display: none; }</style><p>テキスト</p>'
        expect(helper.safe_html(html)).to eq('body { display: none; }<p>テキスト</p>')
      end

      it 'iframeタグが除去されること' do
        html = '<iframe src="https://evil.com"></iframe><p>テキスト</p>'
        expect(helper.safe_html(html)).to eq('<p>テキスト</p>')
      end

      it 'formタグが除去されること' do
        html = '<form action="/evil"><input type="text"><button>送信</button></form>'
        expect(helper.safe_html(html)).to eq('送信')
      end

      it 'javascript:URLが除去されること' do
        html = '<a href="javascript:alert(\'XSS\')">リンク</a>'
        expect(helper.safe_html(html)).to eq('<a>リンク</a>')
      end
    end

    context '許可されていない属性の場合' do
      it 'style属性が除去されること' do
        html = '<p style="color: red; display: none;">テキスト</p>'
        expect(helper.safe_html(html)).to eq('<p>テキスト</p>')
      end

      it 'data-*属性が除去されること' do
        html = '<div data-evil="value">テキスト</div>'
        expect(helper.safe_html(html)).to eq('<div>テキスト</div>')
      end
    end

    context 'nl2brと組み合わせた場合' do
      it '改行が<br>に変換され、安全に出力されること' do
        text = "行1\n行2\r\n行3"
        html = helper.nl2br(text)
        expect(helper.safe_html(html)).to eq("行1<br>\n行2<br>\n行3")
      end

      it 'nl2br後の悪意のあるHTMLも適切に処理されること' do
        text = "テキスト\n<script>alert('XSS')</script>\n続き"
        html = helper.nl2br(text)
        expect(helper.safe_html(html)).to eq("テキスト<br>\nalert('XSS')<br>\n続き")
      end
    end

    context '複雑なHTMLの場合' do
      it '許可されたタグと許可されていないタグが混在する場合' do
        html = <<~HTML
          <div>
            <h2>見出し</h2>
            <script>alert('XSS')</script>
            <p>段落 <strong>強調</strong> テキスト</p>
            <img src="/image.jpg" alt="画像" onerror="alert('XSS')">
            <a href="https://example.com" onclick="return false;">リンク</a>
          </div>
        HTML

        result = helper.safe_html(html)
        expect(result).to include('<h2>見出し</h2>')
        expect(result).to include('<p>段落 <strong>強調</strong> テキスト</p>')
        expect(result).to include('<img src="/image.jpg" alt="画像">')
        expect(result).to include('<a href="https://example.com">リンク</a>')
        expect(result).not_to include('script')
        expect(result).not_to include('onclick')
        expect(result).not_to include('onerror')
      end
    end
  end

  describe '#nl2br' do
    it 'LF改行をbrタグに変換すること' do
      expect(helper.nl2br("行1\n行2")).to eq("行1<br>\n行2")
    end

    it 'CRLF改行をbrタグに変換すること' do
      expect(helper.nl2br("行1\r\n行2")).to eq("行1<br>\n行2")
    end

    it 'nilの場合はnilを返すこと' do
      expect(helper.nl2br(nil)).to be_nil
    end
  end
end
