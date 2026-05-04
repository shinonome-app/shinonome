# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NatsuzoraRenderer do
  describe '#render' do
    it 'renders a natsuzora template with context' do
      templates_root = Rails.application.config.x.natsuzora_templates_root
      renderer = NatsuzoraRenderer.new(templates_root: templates_root)

      # Render the top page template with minimal context
      context = {
        'page_title' => 'テスト',
        'bgcolor' => 'bg-white-100',
        'new_works' => [],
        'new_works_published_on' => '',
        'latest_news_published_on' => '',
        'topics' => [],
        'works_count' => 0,
        'works_copyright_count' => 0,
        'works_noncopyright_count' => 0,
        'editable_content_html' => ''
      }

      html = renderer.render('top/index.ntzr', context)
      expect(html).to include('テスト')
      expect(html).to include('<html')
    end

    it 'raises an error for missing template' do
      renderer = NatsuzoraRenderer.new(templates_root: '/nonexistent/path')

      expect do
        renderer.render('missing.ntzr', {})
      end.to raise_error(Errno::ENOENT)
    end
  end
end
