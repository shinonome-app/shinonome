# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EditableContentRenderer do
  subject(:renderer) { EditableContentRenderer.new(area_name: 'top', key: 'main') }

  let(:context) { { 'works_count' => 12_345 } }

  # rails_helper がシード（公開済み top/main を含む）を読み込むため明示的に空にする
  before { EditableContent.delete_all }

  describe '#render' do
    it 'renders a natsuzora fragment with the given context' do
      html = renderer.render('<p>total: {[ works_count ]}</p>', context)
      expect(html).to eq('<p>total: 12345</p>')
    end

    it 'raises Natsuzora::Error for invalid syntax' do
      expect { renderer.render('{[#if', context) }.to raise_error(Natsuzora::Error)
    end

    it 'raises Natsuzora::Error when the fragment uses include' do
      expect { renderer.render('{[!include /top/body]}', context) }.to raise_error(Natsuzora::Error)
    end
  end

  describe '#render_published' do
    context 'when no published content exists' do
      it 'returns an empty string' do
        expect(renderer.render_published(context)).to eq('')
      end
    end

    context 'with published content' do
      before do
        create(:editable_content, area_name: 'top', key: 'main', status: 'published',
                                  value: '<p>count: {[ works_count ]}</p>')
      end

      it 'renders the latest published fragment' do
        expect(renderer.render_published(context)).to eq('<p>count: 12345</p>')
      end
    end

    context 'with invalid published content' do
      before do
        create(:editable_content, area_name: 'top', key: 'main', status: 'published', value: '{[#if')
      end

      it 'returns an empty string and logs the error' do
        allow(Rails.logger).to receive(:error)
        expect(renderer.render_published(context)).to eq('')
        expect(Rails.logger).to have_received(:error).with(/EditableContentRenderer/)
      end
    end

    context 'with blank published content' do
      before do
        create(:editable_content, area_name: 'top', key: 'main', status: 'published', value: '')
      end

      it 'returns an empty string' do
        expect(renderer.render_published(context)).to eq('')
      end
    end
  end
end
