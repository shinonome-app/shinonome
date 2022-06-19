# frozen_string_literal: true

# 全WorkfileをActiveStorageからファイルシステムに移動させる
class WorkfileRetriever
  def retrive_workfiles(dir: 'data/workfiles')
    Work.joins(:workfiles).order(id: :asc).each do |work|
      work.workfiles.preload(:compresstype).order(id: :asc).each do |workfile|
        workfile_path = Rails.root.join(dir, 'cards', work.card_person_id, 'files', workfile.filename)
        FileUtils.mkdir_p(File.dirname(workfile_path))
        workfile.workdata.open do |file|
          File.binwrite(workfile_path, file.read)
        end
        Rails.logger.debug { "Output workfile: #{work.id}, #{workfile.filename}, #{work.title}" }
      end
    end
  end
end
