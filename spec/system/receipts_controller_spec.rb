# frozen_string_literal: true

require 'rails_helper'

describe ReceiptsController do
  describe '#new' do
    it 'トップページから入力受付システムに遷移する' do
      visit '/'
      click_link('入力受付システム', href: '/receipts/new') # rubocop:disable Capybara/ClickLinkOrButtonStyle

      expect(page).to have_content('入力受付システム：必要事項の記入')
    end

    it '何も入力せずに確認するとエラーが表示される' do
      visit '/receipts/new'

      click_on('確認')

      expect(page).to have_content('13件のエラーが見つかりました')
    end

    it '一通り入力して確認すると確認画面に進む' do
      visit '/receipts/new'
      fill_in '耕作員読み', with: 'あおぞらたろう'
      fill_in '耕作員名', with: '青空太郎'
      fill_in 'e-mail', with: 'test@example.com'
      fill_in 'ホームページ', with: 'http://sample.example.com'
      fill_in 'receipt_form_last_name_kana', with: 'あくたがわ'
      fill_in 'receipt_form_last_name', with: '芥川'
      fill_in 'receipt_form_first_name_kana', with: 'りゅうのすけ'
      fill_in 'receipt_form_first_name', with: '竜之介'
      fill_in 'receipt_form_person_note', with: '備考テスト'
      fill_in '底本名', with: '芥川龍之介全集２'
      fill_in 'receipt_form_publisher', with: 'ちくま文庫、筑摩書房'
      fill_in 'receipt_form_first_pubdate', with: '1986（昭和61）年10月28日'
      fill_in 'receipt_form_input_edition', with: '1996（平成8）年7月15日第11刷'
      fill_in 'receipt_form_original_book_note', with: '底本の備考'
      fill_in '底本の親本名', with: '筑摩全集類聚版芥川龍之介全集'
      fill_in '底本の親本出版社名', with: '筑摩書房'
      fill_in '底本の親本初版発行年', with: '1971（昭和46）年3月～11月に刊行'
      fill_in '作品名読み', with: 'くものいと'
      fill_in 'receipt_form_sub_works_attributes_0_title', with: '蜘蛛の糸'
      fill_in 'receipt_form_sub_works_attributes_0_subtitle_kana', with: 'ふくだいさんぷる'
      fill_in 'receipt_form_sub_works_attributes_0_subtitle', with: '副題サンプル'
      fill_in '原題', with: '原題サンプル'
      select '旧字旧仮名', from: 'receipt_form_sub_works_attributes_0_kana_type_id'
      fill_in '初出', with: '「赤い鳥」1918（大正7）年7月'
      fill_in '作品について', with: '作品についてサンプル'
      fill_in 'receipt_form_sub_works_attributes_0_note', with: '作品備考サンプル'
      choose 'receipt_form_sub_works_attributes_0_copyright_flag_0'

      click_on('確認')
      expect(page).to have_current_path receipts_previews_path, ignore_query: true

      expect(page).to have_content('入力受付システム：記入事項の確認')
      expect(page).to have_content('青空太郎')
      expect(page).to have_content('芥川龍之介全集２')
      expect(page).to have_content('「赤い鳥」1918（大正7）年7月')
      expect(page).to have_content('作品についてサンプル')
      expect(page).to have_content('旧字旧仮名')
    end

    it '一通り入力して確認→登録すると登録される' do
      visit '/receipts/new'
      fill_in '耕作員読み', with: 'あおぞらたろう'
      fill_in '耕作員名', with: '青空太郎'
      fill_in 'e-mail', with: 'test@example.com'
      fill_in 'ホームページ', with: 'http://sample.example.com'
      fill_in 'receipt_form_last_name_kana', with: 'あくたがわ'
      fill_in 'receipt_form_last_name', with: '芥川'
      fill_in 'receipt_form_first_name_kana', with: 'りゅうのすけ'
      fill_in 'receipt_form_first_name', with: '竜之介'
      fill_in 'receipt_form_person_note', with: '備考テスト'
      fill_in '底本名', with: '芥川龍之介全集２'
      fill_in 'receipt_form_publisher', with: 'ちくま文庫、筑摩書房'
      fill_in 'receipt_form_first_pubdate', with: '1986（昭和61）年10月28日'
      fill_in 'receipt_form_input_edition', with: '1996（平成8）年7月15日第11刷'
      fill_in 'receipt_form_original_book_note', with: '底本の備考'
      fill_in '底本の親本名', with: '筑摩全集類聚版芥川龍之介全集'
      fill_in '底本の親本出版社名', with: '筑摩書房'
      fill_in '底本の親本初版発行年', with: '1971（昭和46）年3月～11月に刊行'
      fill_in '作品名読み', with: 'くものいと'
      fill_in 'receipt_form_sub_works_attributes_0_title', with: '蜘蛛の糸'
      fill_in 'receipt_form_sub_works_attributes_0_subtitle_kana', with: 'ふくだいさんぷる'
      fill_in 'receipt_form_sub_works_attributes_0_subtitle', with: '副題サンプル'
      fill_in '原題', with: '原題サンプル'
      select '旧字旧仮名', from: 'receipt_form_sub_works_attributes_0_kana_type_id'
      fill_in '初出', with: '「赤い鳥」1918（大正7）年7月'
      fill_in '作品について', with: '作品についてサンプル'
      fill_in 'receipt_form_sub_works_attributes_0_note', with: '作品備考サンプル'
      choose 'receipt_form_sub_works_attributes_0_copyright_flag_0'

      click_on('確認')
      click_on('登録')

      expect(page).to have_current_path receipts_thanks_path

      expect(page).to have_content('入力受付システム：受付完了')
      expect(page).to have_content('入力をお申し込みいただき、ありがとうございました。')

      receipt = Receipt.last
      expect(receipt.last_name).to eq '芥川'
      expect(receipt.last_name_kana).to eq 'あくたがわ'
      expect(receipt.first_name).to eq '竜之介'
      expect(receipt.first_name_kana).to eq 'りゅうのすけ'
      expect(receipt.worker_kana).to eq 'あおぞらたろう'
      expect(receipt.worker_name).to eq '青空太郎'
      expect(receipt.url).to eq 'http://sample.example.com'
      expect(receipt.publisher).to eq 'ちくま文庫、筑摩書房'
      expect(receipt.publisher2).to eq '筑摩書房'
    end

    it '存在しない耕作員IDを入力するとエラーが表示される' do
      visit '/receipts/new'
      fill_in '耕作員ID', with: '111111111'
      fill_in '耕作員読み', with: 'あおぞらたろう'
      fill_in '耕作員名', with: '青空太郎'
      fill_in 'e-mail', with: 'test@example.com'
      fill_in 'receipt_form_last_name_kana', with: 'あくたがわ'
      fill_in 'receipt_form_last_name', with: '芥川'
      fill_in 'receipt_form_first_name_kana', with: 'りゅうのすけ'
      fill_in 'receipt_form_first_name', with: '竜之介'
      fill_in 'receipt_form_person_note', with: '備考テスト'
      fill_in '底本名', with: '芥川龍之介全集２'
      fill_in 'receipt_form_publisher', with: 'ちくま文庫、筑摩書房'
      fill_in 'receipt_form_first_pubdate', with: '1986（昭和61）年10月28日'
      fill_in 'receipt_form_input_edition', with: '1996（平成8）年7月15日第11刷'
      fill_in 'receipt_form_original_book_note', with: '底本の備考'
      fill_in '底本の親本名', with: '筑摩全集類聚版芥川龍之介全集'
      fill_in '底本の親本出版社名', with: '筑摩書房'
      fill_in '底本の親本初版発行年', with: '1971（昭和46）年3月～11月に刊行'
      fill_in '作品名読み', with: 'くものいと'
      fill_in 'receipt_form_sub_works_attributes_0_title', with: '蜘蛛の糸'
      fill_in 'receipt_form_sub_works_attributes_0_subtitle_kana', with: 'ふくだいさんぷる'
      fill_in 'receipt_form_sub_works_attributes_0_subtitle', with: '副題サンプル'
      fill_in '原題', with: '原題サンプル'
      select '旧字旧仮名', from: 'receipt_form_sub_works_attributes_0_kana_type_id'
      fill_in '初出', with: '「赤い鳥」1918（大正7）年7月'
      fill_in '作品について', with: '作品についてサンプル'
      fill_in 'receipt_form_sub_works_attributes_0_note', with: '作品備考サンプル'
      choose 'receipt_form_sub_works_attributes_0_copyright_flag_0'

      click_on('確認')
      expect(page).to have_content('1件のエラーが見つかりました')
      expect(page).to have_content('耕作員IDは不正な値です')
    end

    it '正しい耕作員IDを入力すると、耕作員名がなくてもエラーにはならない' do
      worker = create(:worker)
      visit '/receipts/new'
      fill_in '耕作員ID', with: worker.id
      fill_in 'e-mail', with: 'test@example.com'
      fill_in 'receipt_form_last_name_kana', with: 'あくたがわ'
      fill_in 'receipt_form_last_name', with: '芥川'
      fill_in 'receipt_form_first_name_kana', with: 'りゅうのすけ'
      fill_in 'receipt_form_first_name', with: '竜之介'
      fill_in 'receipt_form_person_note', with: '備考テスト'
      fill_in '底本名', with: '芥川龍之介全集２'
      fill_in 'receipt_form_publisher', with: 'ちくま文庫、筑摩書房'
      fill_in 'receipt_form_first_pubdate', with: '1986（昭和61）年10月28日'
      fill_in 'receipt_form_input_edition', with: '1996（平成8）年7月15日第11刷'
      fill_in 'receipt_form_original_book_note', with: '底本の備考'
      fill_in '底本の親本名', with: '筑摩全集類聚版芥川龍之介全集'
      fill_in '底本の親本出版社名', with: '筑摩書房'
      fill_in '底本の親本初版発行年', with: '1971（昭和46）年3月～11月に刊行'
      fill_in '作品名読み', with: 'くものいと'
      fill_in 'receipt_form_sub_works_attributes_0_title', with: '蜘蛛の糸'
      fill_in 'receipt_form_sub_works_attributes_0_subtitle_kana', with: 'ふくだいさんぷる'
      fill_in 'receipt_form_sub_works_attributes_0_subtitle', with: '副題サンプル'
      fill_in '原題', with: '原題サンプル'
      select '旧字旧仮名', from: 'receipt_form_sub_works_attributes_0_kana_type_id'
      fill_in '初出', with: '「赤い鳥」1918（大正7）年7月'
      fill_in '作品について', with: '作品についてサンプル'
      fill_in 'receipt_form_sub_works_attributes_0_note', with: '作品備考サンプル'
      choose 'receipt_form_sub_works_attributes_0_copyright_flag_0'

      click_on('確認')
      expect(page).to have_content('記入事項の確認')
      expect(page).to have_content('以下の内容で、入力を申し込みます')
      expect(page).to have_content(worker.name)
    end
  end
end
