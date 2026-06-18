# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NatsuzoraContext::CardBuilder do
  describe '#build' do
    subject(:context) { NatsuzoraContext::CardBuilder.new(work, person.id).build }

    let(:non_copyright_person) { create(:person, copyright_flag: false) }
    let(:work) do
      w = create(:work, title: 'テスト作品', copyright_flag: false)
      create(:work_person, work: w, person: non_copyright_person, role_id: 1)
      w
    end
    let(:person) { non_copyright_person }

    it 'returns a Hash' do
      expect(context).to be_a(Hash)
    end

    it 'sets page_title' do
      expect(context['page_title']).to eq('図書カード：テスト作品 | 青空文庫')
    end

    it 'sets bgcolor to bg-sky-50 for non-copyrighted works' do
      expect(context['bgcolor']).to eq('bg-sky-50')
    end

    it 'sets bgcolor to bg-rose-50 for copyrighted works' do
      person.update!(copyright_flag: true)
      work.reload
      expect(context['bgcolor']).to eq('bg-rose-50')
    end

    it 'sets work_id and person_id' do
      expect(context['work_id']).to eq(work.id)
      expect(context['person_id']).to eq(person.id)
    end

    it 'sets title fields' do
      expect(context['title']).to eq('テスト作品')
    end

    it 'sets card_path' do
      expect(context['card_path']).to eq("/cards/#{format('%06d', person.id)}/card#{work.id}.html")
    end

    it 'converts newlines in description to <br> (komadome / komadome-rs と同一)' do
      work.update!(description: "一行目\r\n二行目\n三行目")
      expect(context['description']).to eq('一行目<br>二行目<br>三行目')
    end

    it 'converts newlines in person description (work_people_details) to <br>' do
      non_copyright_person.update!(description: "人物\r\n説明\n行")
      expect(context['work_people_details'].first['description']).to eq('人物<br>説明<br>行')
    end

    it 'sets has_copyright flag to false for non-copyrighted person' do
      expect(context['has_copyright']).to eq(false)
    end

    it 'builds authors array' do
      expect(context['authors']).to be_an(Array)
      expect(context['authors'].length).to eq(1)
      expect(context['authors'].first['id']).to eq(person.id)
    end

    it 'builds empty translators and editors arrays' do
      expect(context['translators']).to eq([])
      expect(context['editors']).to eq([])
    end

    it 'builds workfiles array' do
      expect(context['workfiles']).to be_an(Array)
    end

    it 'builds work_people_details array' do
      expect(context['work_people_details']).to be_an(Array)
      expect(context['work_people_details'].first['person_id']).to eq(person.id)
    end

    it 'sets external URLs' do
      expect(context['booklog_url']).to include(work.id.to_s)
      expect(context['voyger_url']).to include(work.id.to_s)
      expect(context['airzoshi_url']).to include(work.id.to_s)
    end

    it 'produces valid context for natsuzora rendering' do
      renderer = NatsuzoraRenderer.new
      html = renderer.render('cards/show.ntzr', context)
      expect(html).to include('テスト作品')
      expect(html).to include('<html')
    end

    it 'produces context that passes contract validation' do
      contract_file = load_contract('cards/show')
      expect { Natsuzora::Contract.validate(contract_file, context) }.not_to raise_error
    end
  end
end
