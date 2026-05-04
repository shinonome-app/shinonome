# frozen_string_literal: true

# Renders natsuzora (.ntzr) templates with a given context hash.
class NatsuzoraRenderer
  def initialize(templates_root: Rails.application.config.x.natsuzora_templates_root)
    @templates_root = templates_root
  end

  def render(template_name, context)
    source = File.read(File.join(@templates_root, template_name), encoding: 'UTF-8')
    Natsuzora.render(source, context, include_root: @templates_root)
  end
end
