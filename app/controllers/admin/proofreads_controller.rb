# frozen_string_literal: true

module Admin
  # Web入力受付管理
  class ProofreadsController < Admin::ApplicationController
    # GET /admin/proofreads
    def index
      @proofreads = Proofread.active.order(id: :desc)
    end

    # 送付内容確認
    def show
      @proofread = Proofread.find(params[:id])
      @worker = @proofread.worker
      @worker_secret = @worker.worker_secret
      @work = @proofread.work
    end

    # GET /admin/proofreads/1/edit
    def edit
      proofread = Proofread.find(params[:id])

      if proofread.ordered?
        redirect_to admin_proofread_path(proofread)
        return
      end

      if proofread.assigned? ## && proofread.non_ordered?
        redirect_to orders_new_admin_proofread_path(proofread)
        return
      end

      @proofread_form =
        if params[:admin_proofread_form]
          Admin::ProofreadForm.new(proofread_form_params, proofread:, current_admin_user:)
        else
          Admin::ProofreadForm.new(proofread:, current_admin_user:)
        end

      if params[:admin_proofread_form]
        @proofread_form.worker_name = params[:admin_proofread_form][:worker_name]
        @proofread_form.worker_kana = params[:admin_proofread_form][:worker_kana]
        @proofread_form.email = params[:admin_proofread_form][:email]
        @proofread_form.url = params[:admin_proofread_form][:url]
      end

      @worker, @worker_secret = @proofread_form.worker_and_worker_secret

      # @searched_workers = @proofread_form.search_similar_workers
    end

    # PATCH/PUT /admin/proofreads/1
    def update
      proofread = Proofread.find(params[:id])

      @proofread_form = Admin::ProofreadForm.new(proofread_form_params, proofread:, current_admin_user:)
      if @proofread_form.save
        redirect_to admin_proofreads_path, success: '更新しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        @worker, @worker_secret = @proofread_form.worker_and_worker_secret
        render 'admin/proofreads/edit', status: :unprocessable_entity
      end
    end

    # DELETE /admin/proofreads/1
    def destroy
      proofread = Proofread.find(params[:id])
      proofread.deleted_at = Time.zone.now
      proofread.save!
      redirect_to admin_proofreads_url, success: '削除しました.'
    end

    private

    # Only allow a list of trusted parameters through.
    def proofread_form_params
      params.require(:admin_proofread_form).permit(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana,
                                                   :original_title, :kana_type_id, :author_display_name,
                                                   :work_id, :worker_id,
                                                   :original_book_title, :publisher, :first_pubdate,
                                                   :input_edition, :proof_edition,
                                                   :original_book_title2, :publisher2, :first_pubdate2,
                                                   :worker_name, :worker_kana,
                                                   :email, :url)
    end
  end
end
