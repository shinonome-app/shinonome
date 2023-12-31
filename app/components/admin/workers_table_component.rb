# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class WorkersTableComponent < ViewComponent::Base
    include ::Pagy::Frontend

    def initialize(workers:, pagy:)
      super
      @header = %w[工作員ID 姓名 読み]
      @workers = workers
      @pagy = pagy
    end

    def before_render
      @body = @workers.map do |worker|
        [worker.id, link_to(worker.name, admin_worker_path(worker)), worker.name_kana]
      end
    end
  end
end
