class Idlists::PeopleController < ApplicationController
  def index
    key = params[:key][0] + "%"
    people = Person.where("last_name_kana like ?", key).order(:sortkey, :last_name_kana, :sortkey2, :first_name_kana, :id)
    @count = people.count
    @people = people.all
  end
end
