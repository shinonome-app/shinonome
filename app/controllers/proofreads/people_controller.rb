# frozen_string_literal: true

module Proofreads
  class PeopleController < ApplicationController
    include Pagy::Backend

    # GET /proofreads/people
    def index
      key = "#{params[:key]&.slice(0, 1)}%"
      people = Person.where('last_name_kana like ?', key)
                     .order(:sortkey, :last_name_kana, :sortkey2, :first_name_kana, :id)
      @pagy, @people = pagy(people.all)
    end

    # GET /proofreads/people/1
    def show; end
  end
end
