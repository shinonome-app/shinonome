# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextSearcher do
  describe '#add_query_param' do
    let(:text_searcher) { TextSearcher.new }

    context 'text_selector_id が 1 (を含む) の場合' do
      it 'LIKE クエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 1)

        where_key, *params = text_searcher.where_params

        expect(where_key).to eq('name like ?')
        expect(params).to eq(['%テスト%'])
      end
    end

    context 'text_selector_id が 2 (で始まる) の場合' do
      it 'LIKE クエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 2)

        where_key, *params = text_searcher.where_params

        expect(where_key).to eq('name like ?')
        expect(params).to eq(['テスト%'])
      end
    end

    context 'text_selector_id が 3 (で終わる) の場合' do
      it 'LIKE クエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 3)

        where_key, *params = text_searcher.where_params

        expect(where_key).to eq('name like ?')
        expect(params).to eq(['%テスト'])
      end
    end

    context 'text_selector_id が 4 (と等しい) の場合' do
      it 'EQUAL クエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 4)

        where_key, *params = text_searcher.where_params

        expect(where_key).to eq('name = ?')
        expect(params).to eq(['テスト'])
      end
    end

    context 'textが空の場合' do
      it 'クエリを追加しない' do
        text_searcher.add_query_param('name', '', 1)
        where_key, *params = text_searcher.where_params
        expect(where_key).to eq('true')
        expect(params).to be_empty
      end
    end

    context '無効な text_selector_id の場合' do
      it '例外を発生させる' do
        expect { text_searcher.add_query_param('name', 'テスト', 999) }.to raise_error(RuntimeError, 'invalid query')
      end
    end
  end

  describe '#where_params' do
    let(:text_searcher) { TextSearcher.new }

    context 'クエリパラメータが空の場合' do
      it '全件検索を示すクエリを返す' do
        where_key, *params = text_searcher.where_params

        expect(where_key).to eq('true')
        expect(params).to be_empty
      end
    end

    context '複数のクエリパラメータがある場合' do
      it 'AND で結合されたクエリを生成する' do
        text_searcher.add_query_param('name', 'テスト', 1)
        text_searcher.add_query_param('email', 'example', 2)

        where_key, *params = text_searcher.where_params

        expect(where_key).to eq('name like ? AND email like ?')
        expect(params).to eq(['%テスト%', 'example%'])
      end
    end
  end
end
