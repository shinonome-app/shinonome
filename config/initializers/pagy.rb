# frozen_string_literal: true

require_relative '../../app/lib/pagy/snm_extra'

Pagy::DEFAULT[:limit] = 30
Pagy::DEFAULT[:size] = 11
Pagy::I18n.load(locale: 'ja')
