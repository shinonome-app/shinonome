# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NatsuzoraContext::PersonBuilder do
  describe '#build' do
    subject(:context) { NatsuzoraContext::PersonBuilder.new(person).build }

    let(:person) { create(:person, last_name: '夏目', first_name: '漱石', last_name_kana: 'なつめ', first_name_kana: 'そうせき', copyright_flag: false, sortkey: 'なつめ') }

    it 'returns a Hash' do
      expect(context).to be_a(Hash)
    end

    it 'sets page_title' do
      expect(context['page_title']).to eq('作家別作品リスト：夏目 漱石 | 青空文庫')
    end

    it 'sets bgcolor based on copyright' do
      expect(context['bgcolor']).to eq('bg-sky-50')
    end

    it 'sets bgcolor to bg-rose-50 for copyrighted person' do
      person.update!(copyright_flag: true)
      expect(context['bgcolor']).to eq('bg-rose-50')
    end

    it 'sets person_id' do
      expect(context['person_id']).to eq(person.id)
    end

    it 'sets name fields' do
      expect(context['last_name']).to eq('夏目')
      expect(context['first_name']).to eq('漱石')
      expect(context['full_name']).to eq('夏目 漱石')
      expect(context['full_name_kana']).to eq('なつめ そうせき')
    end

    it 'sets kana and kana_fragment' do
      expect(context['kana']).to be_a(String)
      expect(context['kana_fragment']).to match(/\Asec\d+\z/)
    end

    it 'sets works array (empty for new person)' do
      expect(context['works']).to eq([])
    end

    it 'sets has_unpublished_works' do
      expect(context['has_unpublished_works']).to eq(false)
    end

    it 'sets other_base_people' do
      expect(context['other_base_people']).to eq([])
    end

    it 'sets sites' do
      expect(context['sites']).to eq([])
    end

    it 'produces valid context for natsuzora rendering' do
      renderer = NatsuzoraRenderer.new
      html = renderer.render('people/show.ntzr', context)
      expect(html).to include('夏目 漱石')
      expect(html).to include('<html')
    end

    it 'produces context that passes contract validation' do
      contract_file = load_contract('people/show')
      expect { Natsuzora::Contract.validate(contract_file, context) }.not_to raise_error
    end
  end
end
