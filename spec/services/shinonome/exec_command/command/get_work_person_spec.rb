# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetWorkPerson do
  describe '.execute' do
    before do
      create(:work_person)
      work_person2 = create(:work_person)
      create(:work_person, work: work_person2.work, role_id: 2)
    end

    it '正しいCSVが生成される' do
      command = Shinonome::ExecCommand::Command.new(['book_person'])

      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetWorkPerson.new.execute(command, output_dir: dir)
        output_file = File.join(dir, 'book_person.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}bookid,人物id,役割フラグ\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          work2 = Work.find(row2[0])
          author2 = work2.first_author
          expect(row2[0]).to eq work2.id.to_s
          expect(row2[1]).to eq author2.id.to_s
          expect(row2[2]).to eq work2.work_people[0].role.name

          ## line 3
          line3 = f.gets
          row3 = CSV.parse(line3)[0]
          work3 = Work.find(row3[0])
          author3 = work3.first_author
          expect(row3[0]).to eq work3.id.to_s
          expect(row3[1]).to eq author3.id.to_s
          expect(row3[2]).to eq work3.work_people[0].role.name

          ## line 4
          line4 = f.gets
          row4 = CSV.parse(line4)[0]
          work4 = Work.find(row4[0])
          work_person4 = WorkPerson.where(work: work4, role: 2).first
          expect(row4[0]).to eq work4.id.to_s
          expect(row4[1]).to eq work_person4.person.id.to_s
          expect(row4[2]).to eq work4.work_people[1].role.name
        end
      end
    end
  end
end
