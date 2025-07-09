# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextSearcher do
  describe '#add_query_param' do
    let(:text_searcher) { TextSearcher.new }

    context 'text_selector_id が 1 (を含む) の場合' do
      it 'LIKE クエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 1)

        result = text_searcher.where_conditions

        expect(result).to eq([['name LIKE ?', '%テスト%']])
      end
    end

    context 'text_selector_id が 2 (で始まる) の場合' do
      it 'LIKE クエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 2)

        result = text_searcher.where_conditions

        expect(result).to eq([['name LIKE ?', 'テスト%']])
      end
    end

    context 'text_selector_id が 3 (で終わる) の場合' do
      it 'LIKE クエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 3)

        result = text_searcher.where_conditions

        expect(result).to eq([['name LIKE ?', '%テスト']])
      end
    end

    context 'text_selector_id が 4 (と等しい) の場合' do
      it 'EQUAL クエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 4)

        result = text_searcher.where_conditions

        expect(result).to eq([{ 'name' => 'テスト' }])
      end
    end

    context 'textが空の場合' do
      it 'クエリを追加しない' do
        text_searcher.add_query_param('name', '', 1)
        result = text_searcher.where_conditions
        expect(result).to be_nil
      end
    end

    context '無効な text_selector_id の場合' do
      it '例外を発生させる' do
        expect { text_searcher.add_query_param('name', 'テスト', 999) }.to raise_error(ArgumentError, 'invalid query selector')
      end
    end

    context '無効なカラム名の場合' do
      it '許可されていないカラム名でArgumentErrorが発生すること' do
        expect do
          text_searcher.add_query_param('malicious_column', 'test', 1)
        end.to raise_error(ArgumentError, /Invalid column name: malicious_column/)
      end

      it 'SQL injection攻撃を防ぐこと' do
        expect do
          text_searcher.add_query_param('users; DROP TABLE users; --', 'test', 1)
        end.to raise_error(ArgumentError, /Invalid column name/)
      end

      it 'シンボルでも文字列でも同様に検証されること' do
        expect do
          text_searcher.add_query_param(:invalid_column, 'test', 1)
        end.to raise_error(ArgumentError, /Invalid column name: invalid_column/)
      end
    end

    context '有効なカラム名の場合' do
      it 'すべての許可されたカラムが使用できること' do
        TextSearcher::ALLOWED_COLUMNS.each do |column|
          new_searcher = TextSearcher.new
          expect do
            new_searcher.add_query_param(column, 'test', 1)
          end.not_to raise_error
        end
      end
    end
  end

  describe '#where_conditions' do
    let(:text_searcher) { TextSearcher.new }

    context 'クエリパラメータが空の場合' do
      it 'nilを返す' do
        result = text_searcher.where_conditions

        expect(result).to be_nil
      end
    end

    context '複数のクエリパラメータがある場合' do
      it '条件の配列を返す' do
        text_searcher.add_query_param('name', 'テスト', 1)
        text_searcher.add_query_param('title', 'example', 2)

        result = text_searcher.where_conditions

        expect(result).to eq([
                               ['name LIKE ?', '%テスト%'],
                               ['title LIKE ?', 'example%']
                             ])
      end
    end
  end

  describe '#apply_to' do
    let(:text_searcher) { TextSearcher.new }
    let(:mock_collection) { instance_spy(ActiveRecord::Relation) }

    context 'クエリパラメータが空の場合' do
      it 'そのままcollectionを返す' do
        result = text_searcher.apply_to(mock_collection)

        expect(result).to eq(mock_collection)
      end
    end

    context 'クエリパラメータがある場合' do
      it 'collectionにwhereを適用する' do
        text_searcher.add_query_param('name', 'テスト', 1)
        text_searcher.add_query_param('title', 'example', 4)

        # モックのセットアップ
        filtered_collection1 = instance_spy(ActiveRecord::Relation)
        filtered_collection2 = instance_spy(ActiveRecord::Relation)

        allow(mock_collection).to receive(:where).with(['name LIKE ?', '%テスト%']).and_return(filtered_collection1)
        allow(filtered_collection1).to receive(:where).with({ 'title' => 'example' }).and_return(filtered_collection2)

        result = text_searcher.apply_to(mock_collection)

        expect(result).to eq(filtered_collection2)
        expect(mock_collection).to have_received(:where).with(['name LIKE ?', '%テスト%'])
        expect(filtered_collection1).to have_received(:where).with({ 'title' => 'example' })
      end
    end
  end
end
