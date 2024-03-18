# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::AddWork do
  describe '.execute' do
    let(:user) { create(:user) }
    let(:args) do
      {
        title: 'タイトル1',
        title_kana: 'たいとる1',
        subtitle: '副題1',
        subtitle_kana: 'ふくだい1',
        collection: '',
        collection_kana: '',
        original_title: '原題1',
        kana_type_name: '新字新仮名',
        first_appearance: '1950年3月6日',
        description: '作品説明1',
        note: '備考1',
        orig_text: 'dummy1',
        work_status_name: '入力中',
        started_on: '2022-10-12',
        copyright_name: 'なし',
        sortkey: 'たいとる',
        user_id: user.id
      }
    end

    context '正しい引数を与えた場合' do
      it 'workを含むResultを返す' do
        row = args.values_at(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana, :original_title,
                             :kana_type_name, :first_appearance, :description, :note, :orig_text, :work_status_name, :started_on, :copyright_name, :sortkey, :user_id)
        command = Shinonome::ExecCommand::Command.new(['作品新規', *row])

        result = Shinonome::ExecCommand::Command::AddWork.new.execute(command)
        expect(result).to be_successful
        command = result.command_result
        expect(command.title).to eq 'タイトル1'
        expect(command.title_kana).to eq 'たいとる1'
        expect(command.subtitle).to eq '副題1'
        expect(command.collection).to eq ''
        expect(command.collection_kana).to eq ''
        expect(command.original_title).to eq '原題1'
        expect(command.kana_type.name).to eq '新字新仮名'
        expect(command.first_appearance).to eq '1950年3月6日'
        expect(command.description).to eq '作品説明1'
        expect(command.note).to eq '備考1'
        expect(command.work_secret.orig_text).to eq 'dummy1'
        expect(command.work_status.name).to eq '入力中'
        expect(command.started_on.to_s).to eq '2022-10-12'
        expect(command.copyright_flag).to be false
        expect(command.sortkey).to eq 'たいとる'
        expect(command.user_id).to eq user.id
      end
    end

    context 'sortkeyがない場合' do
      it 'sortkeyを生成したworkを含むResultを返す' do
        args1 = args.merge(sortkey: '')

        row = args1.values_at(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana, :original_title,
                              :kana_type_name, :first_appearance, :description, :note, :orig_text, :work_status_name, :started_on, :copyright_name, :sortkey, :user_id)
        command = Shinonome::ExecCommand::Command.new(['作品新規', *row])

        result = Shinonome::ExecCommand::Command::AddWork.new.execute(command)
        expect(result).to be_successful
        command = result.command_result
        expect(command.title).to eq 'タイトル1'
        expect(command.title_kana).to eq 'たいとる1'
        expect(command.subtitle).to eq '副題1'
        expect(command.collection).to eq ''
        expect(command.collection_kana).to eq ''
        expect(command.original_title).to eq '原題1'
        expect(command.kana_type.name).to eq '新字新仮名'
        expect(command.first_appearance).to eq '1950年3月6日'
        expect(command.description).to eq '作品説明1'
        expect(command.note).to eq '備考1'
        expect(command.work_secret.orig_text).to eq 'dummy1'
        expect(command.work_status.name).to eq '入力中'
        expect(command.started_on.to_s).to eq '2022-10-12'
        expect(command.copyright_flag).to be false
        expect(command.sortkey).to eq 'たいとる'
        expect(command.user_id).to eq user.id
      end
    end

    context '著作権フラグの値が正しくない場合' do
      it '例外をあげる' do
        args2 = args.merge(copyright_name: '保護期間終了')
        row = args2.values_at(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana, :original_title,
                              :kana_type_name, :first_appearance, :description, :note, :orig_text, :work_status_name, :started_on, :copyright_name, :sortkey, :user_id)
        command = Shinonome::ExecCommand::Command.new(['作品新規', *row])

        expect do
          Shinonome::ExecCommand::Command::AddWork.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '著作権フラグには"あり"か"なし"を指定してください。'
        )
      end
    end

    context '文字遣い種別の値が正しくない場合' do
      it '例外をあげる' do
        args3 = args.merge(kana_type_name: '新字')
        row = args3.values_at(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana, :original_title,
                              :kana_type_name, :first_appearance, :description, :note, :orig_text, :work_status_name, :started_on, :copyright_name, :sortkey, :user_id)
        command = Shinonome::ExecCommand::Command.new(['作品新規', *row])
        expect do
          Shinonome::ExecCommand::Command::AddWork.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '文字遣い種別には"旧字旧仮名"か"旧字新仮名"か"新字旧仮名"か"新字新仮名"か"その他"を指定してください。'
        )
      end
    end

    context '状態の値が正しくない場合' do
      it '例外をあげる' do
        args4 = args.merge(work_status_name: '未入力')
        row = args4.values_at(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana, :original_title,
                              :kana_type_name, :first_appearance, :description, :note, :orig_text, :work_status_name, :started_on, :copyright_name, :sortkey, :user_id)
        command = Shinonome::ExecCommand::Command.new(['作品新規', *row])
        expect do
          Shinonome::ExecCommand::Command::AddWork.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '状態には"公開"か"非公開"か"入力中"か"入力予約"か"校正待ち(点検済み)"か"校正待ち(点検前)"か"校正予約(点検済み)"か"校正予約(点検前)"か"校正中"か"校了"か"翻訳中"か"入力取り消し"か"校了（点検前）"か"校正受領"か"公開保留"を指定してください。'
        )
      end
    end
  end
end
