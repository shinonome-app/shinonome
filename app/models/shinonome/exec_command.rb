# frozen_string_literal: true

# == Schema Information
#
# Table name: exec_commands
#
#  id         :integer          not null, primary key
#  command    :text
#  user_id    :integer
#  separator  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Shinonome
  # コマンド実行用
  class ExecCommand < ApplicationRecord # rubocop:disable Metrics/ClassLength
    class Error < RuntimeError
    end

    enum separator: { tab: 0, comma: 1 }

    belongs_to :user

    validates :command, presence: true

    attr_reader :csv_path

    # 失敗したらerrorを保存してfalseを返す
    def execute(path) # rubocop:disable Metrics/CyclomaticComplexity
      Dir.mktmpdir do |dir|
        @csv_path = dir

        each_command do |cmd, args|
          case cmd
          when '作品新規'
            ExecCommand::AddWork.execute(self, args)
          when '底本追加'
            ExecCommand::AddOriginalBook.execute(self, args)
          when '分類追加'
            ExecCommand::AddBibclass.execute(self, args)
          when '人物追加'
            ExecCommand::AddPerson.execute(self, args)
          when '工作員追加'
            ExecCommand::AddWorker.execute(self, args)
          when 'サイト追加'
            ExecCommand::AddSite.execute(self, args)
          when 'ファイル追加'
            ExecCommand::AddFile.execute(self, args)
          when '作品更新'
            ExecCommand::EditWork.execute(self, args)
          when '底本更新'
            ExecCommand::EditOriginalBook.execute(self, args)
          when '分類更新'
            ExecCommand::EditBibclass.execute(self, args)
          when 'ファイル更新'
            ExecCommand::EditFile.execute(self, args)
          when 'ファイル削除'
            ExecCommand::DeleteFile.execute(self, args)
          when '底本削除'
            ExecCommand::DeleteOriginalBook.execute(self, args)
          when '分類削除'
            ExecCommand::DeleteBibclass.execute(self, args)
          when 'サイト削除'
            ExecCommand::DeleteSite.execute(self, args)
          when '工作員削除'
            ExecCommand::DeleteWorker.execute(self, args)
          when 'SQL'
            ExecCommand::CommandSQL.execute(self, args)
          when 'ファイル取得'
            ExecCommand::GetFile.execute(self, args)
          when 'workselect'
            ExecCommand::GetWorkSelect.execute(self, args)
          when 'work'
            ExecCommand::GetWork.execute(self, args)
          when 'work_site'
            ExecCommand::GetWorkSite.execute(self, args)
          when 'person_site'
            ExecCommand::GetPersonSite.execute(self, args)
          when 'work_person'
            ExecCommand::GetWorkPerson.execute(self, args)
          when 'work_worker'
            ExecCommand::GetWorkWorker.execute(self, args)
          when 'source'
            ExecCommand::GetOriginalBook.execute(self, args)
          when 'class'
            ExecCommand::GetBibclass.execute(self, args)
          when 'person'
            ExecCommand::GetPerson.execute(self, args)
          when 'worker'
            ExecCommand::GetWorker.execute(self, args)
          when 'site'
            ExecCommand::GetSite.execute(self, args)
          when nil
            # skip
          else
            raise ExecCommand::Error, "コマンド'#{cmd}'は存在しません"
          end
        rescue ExecCommand::Error => e
          errors.add(:command, e.message)
        end

        make_zip(dir, path: path)
      end

      errors.empty?
    end

    private

    def each_command
      command.each_line do |line|
        cmd, args = parse_command(line)
        yield cmd, args
      end
    end

    def parse_command(line)
      if line.blank?
        [nil, nil]
      elsif comma?
        CSV.parse(line.chomp)
      else # tab
        line.chomp.split(/\t/)
      end
    end

    def make_zip(zip_dir, path:)
      Zip::ZipOutputStream.open(path) do |f|
        Dir.chdir(zip_dir) do
          Dir.glob('**/*') do |file|
            next unless File.file? file

            logger.info("output #{file}")
            f.put_next_entry file
            f << File.read(file)
          end
        end
      end
    end
  end
end
