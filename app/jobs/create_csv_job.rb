# frozen_string_literal: true

# CSV生成
class CreateCsvJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    csv_dir = Rails.application.config.x.csv_dir
    csv_creator = CsvCreator.new

    unfinished_zip = File.join(csv_dir, 'list_person_inp_all.zip')
    finished_zip = File.join(csv_dir, 'list_person_all.zip')
    extended_zip = File.join(csv_dir, 'list_person_all_extended.zip')

    csv_creator.create_unfinished_zip(filename: unfinished_zip)
    csv_creator.create_finished_zip(filename: finished_zip)
    csv_creator.create_extended_zip(filename: extended_zip)
  end
end
