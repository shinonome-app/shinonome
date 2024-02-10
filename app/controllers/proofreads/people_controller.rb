# frozen_string_literal: true

module Proofreads
  class PeopleController < ApplicationController
    include Pagy::Backend

    # GET /proofreads/people?people=a
    def index
      if params[:people].present?
        @kana = Kana.from_string(params[:people]).to_char
        @authors = Person.with_name_firstchar(@kana).order(sortkey: :asc)
      else
        @kana = '全て'
        @authors = Person.joins(:works).where('works.work_status_id in (5, 6)').group('people.id').order(sortkey: :asc)
      end
    end

    # GET /proofreads/people/1
    def show
      @author = Person.find(params[:id])
      @proofread_form = ProofreadForm.new_by_author(@author)
    end
  end
end
