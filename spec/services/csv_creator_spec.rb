# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvCreator do
  describe '#make_utf8_filename' do
    it '与えられたファイル名に対し"_utf8"をつけた形に変換する' do
      csv_creator = CsvCreator.new
      expect(csv_creator.make_utf8_filename('foo_bar.csv')).to eq('foo_bar_utf8.csv')
      expect(csv_creator.make_utf8_filename('foo_bar.zip')).to eq('foo_bar_utf8.zip')
    end
  end

  describe '#convert_to_sjis' do
    it 'BOMつきUTF8ファイルをShift_JISに変換する' do
      csv_creator = CsvCreator.new
      Dir.mktmpdir do |dir|
        src = File.join(dir, 'src.txt')
        dest = File.join(dir, 'dest.txt')
        File.open(src, 'wb:UTF-8') do |f|
          f.write("UTF-8変換テスト用ファイル\n")
        end

        csv_creator.convert_to_sjis(from: src, to: dest)

        File.open(dest, 'rb:Shift_JIS') do |f|
          line = f.gets
          expect(line).to eq "UTF-8変換テスト用ファイル\n"
        end
      end
    end
  end
end
