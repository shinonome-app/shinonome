# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HtmlSanitizer do
  describe '#sanitize' do
    subject(:sanitized) { HtmlSanitizer.new.sanitize(html) }

    context 'with nil' do
      let(:html) { nil }

      it { is_expected.to eq('') }
    end

    context 'with tags used in existing data' do
      let(:html) do
        '<a href="http://ja.wikipedia.org/" target="_blank">' \
          '<img align="middle" src="../images/wikipedia_logo_rounded.png" width="110" height="32" border="0" alt="icon">' \
          '</a><br><i>The Year</i><s>old</s><font color="#AA0000">作者より：</font><blockquote>引用</blockquote>'
      end

      it 'keeps them as is' do
        expect(sanitized).to eq(html)
      end
    end

    context 'with script tags' do
      let(:html) { '前<script>alert(1)</script>後' }

      it 'removes the script element with its content' do
        expect(sanitized).to eq('前後')
      end
    end

    context 'with event handler attributes' do
      let(:html) { '<img src="x.png" onerror="alert(1)"><a href="/" onclick="alert(1)">a</a>' }

      it 'removes them' do
        expect(sanitized).not_to include('onerror')
        expect(sanitized).not_to include('onclick')
        expect(sanitized).to include('<img src="x.png">')
      end
    end

    context 'with javascript: URL' do
      let(:html) { '<a href="javascript:alert(1)">x</a><a href="JaVaScRiPt:alert(1)">y</a>' }

      it 'removes the href' do
        expect(sanitized).not_to match(/javascript/i)
      end
    end

    context 'with disallowed tags' do
      let(:html) { '<iframe src="https://example.com"></iframe><style>body{}</style><svg onload="alert(1)"></svg>本文' }

      it 'removes them' do
        expect(sanitized).to eq('本文')
      end
    end

    context 'with unknown tags' do
      let(:html) { '原文は<http://example.com/a.html>［閲覧］<custom>中身</custom>' }

      it 'removes the tags but keeps the text content' do
        expect(sanitized).to eq('原文は［閲覧］中身')
      end
    end
  end
end
