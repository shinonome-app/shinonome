# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::FlashComponent, type: :component do
  context 'noticeがあった場合' do
    it 'HTMLを表示する' do
      flashes = { notice: 'notice message.' }
      flash = ActionDispatch::Flash::FlashHash.new(flashes)
      component = render_inline(Admin::FlashComponent.new(flash:))
      expect(component.css('div').to_html).to include('class="text-sky-950 bg-sky-200 text-sm px-8 py-3 rounded mb-2"')
      expect(component.css('div').to_html).to include('notice message.')
    end
  end

  # it "renders something useful" do
  #   expect(
  #     render_inline(described_class.new(attr: "value")) { "Hello, components!" }.css("p").to_html
  #   ).to include(
  #     "Hello, components!"
  #   )
  # end
end
