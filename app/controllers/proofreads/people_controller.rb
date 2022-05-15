# frozen_string_literal: true

module Proofreads
  class PeopleController < ApplicationController
    include Pagy::Backend

    # GET /proofreads/people?people=a
    def index
      @kana = Kana.new(params[:people].to_sym).to_char
      @authors = if @kana
                  Person.where('sortkey like ?', "#{@kana}%").order(sortkey: :asc)
                else
                  Person.where('sortkey !~ ?', '^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]').order(sortkey: :asc)
                end
    end

    # GET /proofreads/people/1
    def show
      @author = Person.find(params[:id])

      sub_works = @author.works.not_proofread.map do |work|
        ProofreadForm::SubWork.new(work_id: work.id)
      end
      @proofread_form = ProofreadForm.new(sub_works: sub_works, person_id: @author.id)
    end
  end
end
