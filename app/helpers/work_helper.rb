# frozen_string_literal: true

module WorkHelper
  def work_status_mark(status)
    tag.snm_status(statusType: status.color, label: status.name)
  end
end
