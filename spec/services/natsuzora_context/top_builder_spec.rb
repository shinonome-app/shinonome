# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NatsuzoraContext::TopBuilder do
  describe '#build' do
    subject(:context) { NatsuzoraContext::TopBuilder.new.build }

    # rails_helper がシード（公開済み top/main を含む）を読み込むため明示的に空にする
    before { EditableContent.delete_all }

    it 'returns a Hash' do
      expect(context).to be_a(Hash)
    end

    it 'sets page_title' do
      expect(context['page_title']).to eq('青空文庫')
    end

    it 'sets bgcolor' do
      expect(context['bgcolor']).to eq('bg-white-100')
    end

    it 'sets works count' do
      expect(context['works_count']).to be_a(Integer)
    end

    it 'sets new_works as array' do
      expect(context['new_works']).to be_an(Array)
    end

    it 'sets topics as array' do
      expect(context['topics']).to be_an(Array)
    end

    it '「歩みの記録」(topics) は最新10件に絞る' do
      15.times { |i| create(:news_entry, flag: true, published_on: Date.new(2020, 1, 1) + i) }
      expect(context['topics'].size).to eq(10)
    end

    it 'sets editable_content_html to empty string when no published content exists' do
      expect(context['editable_content_html']).to eq('')
    end

    context 'with published editable content' do
      before do
        create(:editable_content, area_name: 'top', key: 'main', status: 'published',
                                  value: '<p>total: {[ works_count ]}</p>')
      end

      it 'renders the published fragment into editable_content_html' do
        expect(context['editable_content_html']).to eq("<p>total: #{Work.published.count}</p>")
      end

      it 'produces context that passes contract validation' do
        contract_file = load_contract('top/index')
        expect { Natsuzora::Contract.validate(contract_file, context) }.not_to raise_error
      end
    end

    context 'with invalid published editable content' do
      before do
        create(:editable_content, area_name: 'top', key: 'main', status: 'published', value: '{[#if')
      end

      it 'falls back to empty string' do
        expect(context['editable_content_html']).to eq('')
      end
    end

    context 'with editable_content_source' do
      subject(:context) { NatsuzoraContext::TopBuilder.new.build(editable_content_source: source) }

      let(:source) { '<p>draft: {[ works_count ]}</p>' }

      it 'renders the given fragment strictly' do
        expect(context['editable_content_html']).to eq("<p>draft: #{Work.published.count}</p>")
      end

      context 'with invalid source' do
        let(:source) { '{[#if' }

        it 'raises Natsuzora::Error' do
          expect { context }.to raise_error(Natsuzora::Error)
        end
      end

      context 'with empty source' do
        let(:source) { '' }

        before do
          create(:editable_content, area_name: 'top', key: 'main', status: 'published',
                                    value: '<p>published</p>')
        end

        it 'ignores published content and sets empty string' do
          expect(context['editable_content_html']).to eq('')
        end
      end
    end

    it 'produces valid context for natsuzora rendering' do
      renderer = NatsuzoraRenderer.new
      html = renderer.render('top/index.ntzr', context)
      expect(html).to include('青空文庫')
      expect(html).to include('<html')
    end

    context 'with published works' do
      before { create(:work, :with_person, work_status_id: 1, started_on: Time.zone.today) }

      it 'includes new works' do
        expect(context['new_works'].length).to be >= 1
        expect(context['new_works'].first).to include('work_id', 'title', 'author_text', 'card_person_dir')
      end

      it 'sets new_works_published_on' do
        expect(context['new_works_published_on']).not_to eq('')
      end
    end

    context 'with topics' do
      before { create(:news_entry, flag: true, published_on: Time.zone.today) }

      it 'includes topics' do
        expect(context['topics'].length).to be >= 1
        expect(context['topics'].first).to include('id', 'title', 'published_on', 'year')
      end
    end

    it 'produces context that passes contract validation' do
      contract_file = load_contract('top/index')
      expect { Natsuzora::Contract.validate(contract_file, context) }.not_to raise_error
    end
  end
end
