# frozen_string_literal: true

require 'fileutils'

Dir.glob('*.scss') do |d|
  d2 = d.sub('scss', 'css')
  FileUtils.mv(d, d2)
end
