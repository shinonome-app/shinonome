# frozen_string_literal: true

module Idlists
  class PeopleController < ApplicationController
    include Pagy::Backend

    def index
      key = "#{params[:key]&.slice(0, 1)}%"
      people = Person.where('last_name_kana like ?', key)
                     .order(:sortkey, :last_name_kana, :sortkey2, :first_name_kana, :id)
      @pagy, @people = pagy(people.all)
    end
  end
end
