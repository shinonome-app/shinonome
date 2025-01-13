# frozen_string_literal: true

module WorkHelper
  def work_status_mark(status)
    render(Admin::SnmStatusComponent.new(status_type: status.color, label: status.name))
  end
end
