# frozen_string_literal: true

module PeopleHelper
  # 「関連した作品」テーブルのソート可能なヘッダリンクを生成する。
  # column は Admin::PeopleController::WORK_SORT_COLUMNS のキー。
  # 現在のソート列はクリックで昇順/降順をトグルし、矢印で向きを示す。
  def related_work_sort_link(person, label, column)
    columns = Admin::PeopleController::WORK_SORT_COLUMNS.keys
    current = columns.include?(params[:sort]) ? params[:sort] : Admin::PeopleController::DEFAULT_WORK_SORT
    current_direction = params[:direction] == 'desc' ? 'desc' : 'asc'

    if current == column
      next_direction = current_direction == 'asc' ? 'desc' : 'asc'
      mark = current_direction == 'asc' ? ' ▲' : ' ▼'
    else
      next_direction = 'asc'
      mark = ''
    end

    link_to("#{label}#{mark}",
            admin_person_path(person, sort: column, direction: next_direction, anchor: 'related-works'),
            class: 'link-normal')
  end
end
