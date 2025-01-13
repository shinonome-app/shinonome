# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SnmMessageBarComponent, type: :component do
  subject(:rendered_component) { render_inline(Admin::SnmMessageBarComponent.new(level:)) { content } }

  let(:content) { 'This is a message' }

  context 'when level is :notice' do
    let(:level) { :notice }

    it 'renders the correct style classes' do
      expect(rendered_component.css('div').attribute('class').value)
        .to eq('text-sky-950 bg-sky-200 text-sm px-8 py-3 rounded mb-2')
    end

    it 'renders the content' do
      expect(rendered_component.text).to include(content)
    end
  end

  context 'when level is :success' do
    let(:level) { :success }

    it 'renders the correct style classes' do
      expect(rendered_component.css('div').attribute('class').value)
        .to eq('text-green-950 bg-green-200 text-sm px-8 py-3 rounded mb-2')
    end

    it 'renders the content' do
      expect(rendered_component.text).to include(content)
    end
  end

  context 'when level is not specified' do
    let(:level) { nil }

    it 'defaults to :notice and renders the correct style classes' do
      expect(rendered_component.css('div').attribute('class').value)
        .to eq('text-sky-950 bg-sky-200 text-sm px-8 py-3 rounded mb-2')
    end

    it 'renders the content' do
      expect(rendered_component.text).to include(content)
    end
  end
end
