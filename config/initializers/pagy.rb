# frozen_string_literal: true

require_relative '../../app/lib/pagy/snm_extra'

Pagy::DEFAULT[:items] = 30
Pagy::I18n.load(locale: 'ja')
