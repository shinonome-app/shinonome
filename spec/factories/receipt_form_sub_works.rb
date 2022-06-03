# frozen_string_literal: true

FactoryBot.define do
  factory :receipt_form_sub_work, class: 'ReceiptForm::SubWork' do
    title_kana { 'くものいと' }
    title { '蜘蛛の糸' }
    kana_type_id { 1 }
    note { '備考' }
    copyright_flag { 1 }
  end
end
