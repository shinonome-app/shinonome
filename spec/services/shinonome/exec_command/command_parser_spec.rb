require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::CommandParser do
  describe '.parse_tsv' do
    let(:command_parser) { Shinonome::ExecCommand::CommandParser.new }

    context '文字列で与える場合' do
      it '正しく解析される' do
        parsed = command_parser.parse_csv("person\n")
        expect(parsed.count).to eq(1)
        expect(parsed[0].comment?).to be_falsey
        expect(parsed[0].command_class).to eq('person')
        expect(parsed[0].name).to eq('person')
        expect(parsed[0].body).to eq([])
      end
    end

    context 'fixtures/commands/command1.csv' do
      let(:command_text) { file_fixture('commands/command1.csv').read }

      it '正しく解析される' do
        parsed = command_parser.parse_csv(command_text)
        expect(parsed.count).to eq(2)
        expect(parsed[0].name).to eq('book_site')
        expect(parsed[0].body).to eq([])

        expect(parsed[1].name).to eq('person_site')
        expect(parsed[1].body).to eq([])
      end
    end

    context 'fixtures/commands/command2.csv' do
      let(:command_text) { file_fixture('commands/command2.csv').read }

      it '正しく解析される' do
        parsed = command_parser.parse_csv(command_text)
        expect(parsed.count).to eq(1)
        expect(parsed[0].name).to eq('作品新規')
        expect(parsed[0].body).to eq(
                                    ["よっかはくま","四日白魔","ロンドンききシリーズ・いち","ロンドン危機シリーズ・１","","","THE FOUR WHITE DAYS: A STORY IN THE \"DOOM OF LONDON\" SERIES","新字新仮名","1903年","極寒に見舞われたロンドン。食料が逼迫、交通が停止、テムズ川も凍りついた。暖房用の石炭を求める人々が貯炭場に押しかけて、警官隊と衝突。（奥増夫）\"<div id=\"link\"></div><script type=\"text/javascript\" src=\"../link.js\"></script>","","入力中","2020-01-03","あり\"よつかはくま"]
                                  )
      end
    end

    context 'fixtures/commands/command3.csv' do
      let(:command_text) { file_fixture('commands/command3.csv').read }

      it '正しく解析される' do
        parsed = command_parser.parse_csv(command_text)
        expect(parsed.count).to eq(5)
        expect(parsed[0].name).to eq('作品新規')
        expect(parsed[0].body).to eq(
                                    ["よっかはくま","四日白魔","ロンドンききシリーズ・いち","ロンドン危機シリーズ・１","","","THE FOUR WHITE DAYS: A STORY IN THE \"DOOM OF LONDON\" SERIES","新字新仮名","1903年","極寒に見舞われたロンドン。食料が逼迫、交通が停止、テムズ川も凍りついた。暖房用の石炭を求める人々が貯炭場に押しかけて、警官隊と衝突。（奥増夫）\"<div id=\"link\"></div><script type=\"text/javascript\" src=\"../link.js\"></script>","","入力中","2020-01-03","あり\"よつかはくま"]
                                  )
        expect(parsed[1].name).to eq('底本追加')
        expect(parsed[1].body).to eq(["The Complete Doom of London Series (Illustrated Edition)","Musaicum Books","2017（平成29）年10月16日","","","底本","NDL国立国会図書館デジタルコレクション"])
      end
    end
  end
end
