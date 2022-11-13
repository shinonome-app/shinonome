# frozen_string_literal: true

task stats: 'shinonome:statsetup'

namespace :shinonome do
  task statsetup: :environment do
    ::STATS_DIRECTORIES << ['Forms', 'app/forms']
    ::STATS_DIRECTORIES << ['AppLib', 'app/lib']
    ::STATS_DIRECTORIES << ['Services', 'app/services']
  end
end
