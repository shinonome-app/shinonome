# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class WorksTableComponent < ViewComponent::Base
    include ::Pagy::Frontend

    def initialize(works:, pagy:)
      super
      @works = works
      @pagy = pagy
    end

    def before_render
      @header = %w[作品ID 作品名/副題 著者/翻訳者 仮名遣い 状態/状態の開始日]
      @body = @works.map do |work|
        [
          work.id,
          safe_join([link_to(work.title, admin_work_path(work)), tag.br, work.subtitle]),
          safe_join([work.author_text, tag.br, work.translator_text]),
          work.kana_type.name,
          safe_join([tag.snm_status(statusType: work.work_status.color, label: work.work_status.name), tag.br, work.started_on])
        ]
      end
    end
  end
end