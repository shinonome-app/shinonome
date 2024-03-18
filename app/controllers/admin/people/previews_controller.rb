# frozen_string_literal: true

module Admin
  module People
    class PreviewsController < ApplicationController
      layout false

      def show
        @person = Person.find(params[:id])
        render ::Pages::People::ShowPageComponent.new(person: @person)
      end
    end
  end
end
