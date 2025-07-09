# frozen_string_literal: true

# 作品公開レポート生成サービス
class WorkReporter
  attr_reader :past_days, :future_days, :include_details, :works

  def initialize(past_days: 7, future_days: 7, include_details: false)
    @past_days = past_days
    @future_days = future_days
    @include_details = include_details
    @works = nil
  end

  def generate_report
    @works = fetch_works_in_range

    report_data = if include_details
                    generate_detailed_report_data(@works)
                  else
                    generate_simple_report_data(@works)
                  end

    {
      data: report_data,
      count: @works.count,
      period: { start: start_date, end: end_date },
      past_days: past_days,
      future_days: future_days,
      generated_at: Time.current
    }
  end

  private

  def start_date
    @start_date ||= past_days.days.ago.to_date
  end

  def end_date
    @end_date ||= future_days.days.from_now.to_date
  end

  def fetch_works_in_range
    Work.includes(:people, :workfiles)
        .where(started_on: start_date..end_date)
        .order('started_on ASC, id ASC')
  end

  def generate_simple_report_data(works)
    works.map do |work|
      {
        work_id: work.id,
        title: work.title,
        subtitle: work.subtitle,
        started_on: work.started_on,
        authors: work.people.map(&:name).join(', '),
        workfiles_count: work.workfiles.count
      }
    end
  end

  def generate_detailed_report_data(works)
    {
      title: 'Work Publication Report',
      generated: Time.current,
      period: "#{start_date} to #{end_date} (過去#{past_days}日間〜未来#{future_days}日間)",
      total_works: works.count,
      works: works.map { |work| generate_work_data(work) }
    }
  end

  def generate_work_data(work)
    {
      work_id: work.id,
      title: work.title,
      subtitle: work.subtitle,
      collection: work.collection,
      started_on: work.started_on,
      authors: work.people.map(&:name).join(', '),
      workfiles_count: work.workfiles.count,
      workfiles: work.workfiles.map do |workfile|
        {
          id: workfile.id,
          filename: workfile.filename,
          filetype: workfile.filetype&.name,
          compresstype: workfile.compresstype&.name,
          filesize: workfile.filesize,
          registered_on: workfile.registered_on,
          last_updated_on: workfile.last_updated_on
        }
      end,
      description: work.description,
      note: work.note,
      copyright_flag: work.copyright_flag,
      kana_type: work.kana_type&.name,
      work_status: work.work_status&.name
    }
  end
end
