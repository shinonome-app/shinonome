# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetBibclass do
  describe '.execute' do
    before do
      create(:bibclass, name: 'NDC', num: '913', note: nil)
      create(:bibclass, name: 'NDC', num: '914', note: 'dummy note')
    end

    it '正しいCSVが生成される' do
      command = Shinonome::ExecCommand::Command.new(['class'])

      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetBibclass.new.execute(command, output_dir: dir)
        output_file = File.join(dir, 'bibclass.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}bookid,分類名,分類番号,備考\r\n"
          line2 = f.gets
          expect(line2).to end_with %("NDC","913",""\r\n)
          line3 = f.gets
          expect(line3).to end_with %("NDC","914","dummy note"\r\n)
        end
      end
    end
  end
end
