# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NatsuzoraContext::TopBuilder do
  describe '#build' do
    subject(:context) { NatsuzoraContext::TopBuilder.new.build }

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

    it 'sets editable_content_html to empty string by default' do
      expect(context['editable_content_html']).to eq('')
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
