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
    def show; end
  end
end
