# frozen_string_literal: true

module Proofreads
  class PeopleController < ApplicationController
    include Pagy::Backend

    # GET /proofreads/people?people=a
    def index
      @kana = Kana.from_string(params[:people]).to_char
      @authors = if @kana
                   Person.where('sortkey like ?', "#{@kana}%").order(sortkey: :asc)
                 else
                   Person.where('sortkey !~ ?', '^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]').order(sortkey: :asc)
                 end
    end

    # GET /proofreads/people/1
    def show
      @author = Person.find(params[:id])
      @proofread_form = ProofreadForm.new_by_author(@author)
    end
  end
end
