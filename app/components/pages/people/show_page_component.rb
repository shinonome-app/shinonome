# frozen_string_literal: true

module Pages
  module People
    class ShowPageComponent < ViewComponent::Base
      attr_reader :kana_fragment, :kana, :author

      def initialize(person:)
        super
        @author = person
        @kana, index = Kana.from_kana(@author.sortkey.first).to_symbol_and_index
        @kana_fragment = "sec#{index + 1}"
      end
    end
  end
end
