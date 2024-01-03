# frozen_string_literal: true

module Admin
  module Works
    class PreviewsController < ApplicationController
      layout false

      def show
        @work = Work.find(params[:id])
        @person = @work.people.first
        render ::Pages::Cards::ShowPageComponent.new(person_id: @person.id,
                                                     card_id: @work.id)
      end
    end
  end
end
