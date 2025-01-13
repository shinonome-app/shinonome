# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SnmStatusComponent, type: :component do
  subject(:component) { render_inline(Admin::SnmStatusComponent.new(status_type:, label:)) }

  let(:label) { 'Label' }
  let(:status_type) { :green }

  it 'renders the correct style classes' do
    expect(component.css('span').attribute('class').value)
      .to eq('bg-ab_lightgreen text-ab_green px-3 py-1 rounded-full')
  end

  context 'when status_type is yellow' do
    let(:status_type) { :yellow }

    it 'renders the correct style classes' do
      expect(component.css('span').attribute('class').value)
        .to eq('bg-ab_lightyellow text-ab_yellow px-3 py-1 rounded-full')
    end
  end

  context 'when status_type is gray' do
    let(:status_type) { :gray }

    it 'renders the correct style classes' do
      expect(component.css('span').attribute('class').value)
        .to eq('bg-ab_lightgray text-ab_gray px-3 py-1 rounded-full')
    end
  end

  context 'when status_type is not specified' do
    let(:status_type) { nil }

    it 'renders the correct style classes' do
      expect(component.css('span').attribute('class').value)
        .to eq('bg-ab_lightgreen text-ab_green px-3 py-1 rounded-full')
    end
  end
end
