# frozen_string_literal: true

module Admin
  class PeopleController < Admin::ApplicationController
    include Pagy::Backend
    before_action :set_person, only: %i[show edit update destroy]

    # 「関連した作品」テーブルでソート可能な列。
    # キーはURLパラメータ、値は ORDER BY に使うSQLカラム。
    WORK_SORT_COLUMNS = {
      'title' => 'works.sortkey',
      'status' => 'work_statuses.sort_order',
      'started_on' => 'works.started_on'
    }.freeze
    DEFAULT_WORK_SORT = 'title'

    # GET /admin/people
    def index
      @pagy, @people = pagy(Person.order(:id).all)
    end

    # GET /admin/people/1
    def show
      @work_people = sorted_work_people(@person)
    end

    # GET /admin/people/new
    def new
      @person = Person.new
      @person.build_person_secret
    end

    # GET /admin/people/1/edit
    def edit; end

    # POST /admin/people
    def create
      @person = Person.new(person_params)
      @person.updated_user = current_admin_user

      if @person.save
        redirect_to [:admin, @person], success: '追加しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/people/1
    def update
      update_params = person_params.merge(updated_by: current_admin_user.id)
      if @person.update(update_params)
        redirect_to [:admin, @person], success: '更新しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/people/1
    def destroy
      if @person.destroy
        redirect_to admin_people_url, success: '削除しました.'
      else
        redirect_to admin_sites_url, alert: '削除できませんでした.'
      end
    end

    private

    # 「関連した作品」を作品名読み・状態・状態の開始日でソートして返す。
    def sorted_work_people(person)
      sort = WORK_SORT_COLUMNS.key?(params[:sort]) ? params[:sort] : DEFAULT_WORK_SORT
      direction = params[:direction] == 'desc' ? 'DESC' : 'ASC'

      person.work_people
            .joins(work: :work_status)
            .order(Arel.sql("#{WORK_SORT_COLUMNS[sort]} #{direction}"))
            .order('works.id ASC')
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
      @person.build_person_secret if @person.person_secret.blank?
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:last_name, :last_name_kana, :last_name_en, :first_name, :first_name_kana,
                                     :first_name_en, :born_on, :died_on, :copyright_flag, :url,
                                     :description, :basename,
                                     :sortkey, :sortkey2, :input_count, :publish_count,
                                     { person_secret_attributes: %i[id email memo] })
    end
  end
end
