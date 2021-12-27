# frozen_string_literal: true

module Admin
  class BookPeopleController < ApplicationController
    before_action :set_book_person, only: %i[show edit update destroy]

    # GET /book_people
    def index
      @book_people = BookPerson.all
    end

    # GET /book_people/1
    def show; end

    # GET /book_people/new
    def new
      @book_person = BookPerson.new
    end

    # GET /book_people/1/edit
    def edit; end

    # POST /book_people
    def create
      @book_person = BookPerson.new(book_person_params)

      if @book_person.save
        redirect_to @book_person, notice: 'Book person was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /book_people/1
    def update
      if @book_person.update(book_person_params)
        redirect_to @book_person, notice: 'Book person was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /book_people/1
    def destroy
      @book_person.destroy
      redirect_to book_people_url, notice: 'Book person was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_book_person
      @book_person = BookPerson.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_person_params
      params.require(:book_person).permit(:book_id, :person_id, :role_id)
    end
  end
end
