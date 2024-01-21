# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Kana do
  describe '.convert_sortkey' do
    context '正しいひらがなが与えられた場合' do
      it 'ひらがなを返す' do
        expect(Kana.convert_sortkey('あかさたな')).to eq 'あかさたな'
        expect(Kana.convert_sortkey('あがざだなぱっ')).to eq 'あかさたなはつ'
      end
    end

    context 'ひらがな以外を含んだ文字列が与えられた場合' do
      it 'ひらがなのみを返す' do
        expect(Kana.convert_sortkey('ジュウシマツ')).to eq 'しゆうしまつ'
        expect(Kana.convert_sortkey('雨はー降ってる？')).to eq 'はあつてる'
      end
    end
  end

  describe '.from_kana' do
    context '正しいひらがなが与えられた場合' do
      it 'Kanaオブジェクトを返す' do
        expect(Kana.from_kana('あ').to_symbol_and_index).to eq [:a, 0]
        expect(Kana.from_kana('い').to_symbol_and_index).to eq [:a, 1]
        expect(Kana.from_kana('く').to_symbol_and_index).to eq [:ka, 2]
        expect(Kana.from_kana('よ').to_symbol_and_index).to eq [:ya, 2]
        expect(Kana.from_kana(nil).to_symbol_and_index).to eq [:zz, 0]
      end
    end
  end

  describe '.from_string' do
    context '文字列が与えられた場合' do
      it 'Kanaオブジェクトを返す' do
        expect(Kana.from_string('a').to_char).to eq 'あ'
        expect(Kana.from_string('i').to_char).to eq 'い'
        expect(Kana.from_string('ku').to_char).to eq 'く'
        expect(Kana.from_string('yo').to_char).to eq 'よ'
        expect(Kana.from_string('zz').to_char).to eq nil
      end
    end
  end

  describe '#to_chars' do
    context '正しいシンボルが与えられた場合' do
      it '配列を返す' do
        expect(Kana.new(:a).to_chars).to eq %w[あ い う え お]
        expect(Kana.new(:ka).to_chars).to eq %w[か き く け こ]
        expect(Kana.new(:wa).to_chars).to eq %w[わ を ん]
        expect(Kana.new(:zz).to_chars).to eq []
      end
    end

    context '正しくないシンボルが与えられた場合' do
      it '例外をあげる' do
        expect { Kana.new(:foo).to_chars }.to raise_error(Kana::Error)
        expect { Kana.new(:mi).to_chars }.to raise_error(Kana::Error)
      end
    end
  end
end
