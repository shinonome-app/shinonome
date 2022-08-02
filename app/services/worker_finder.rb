# frozen_string_literal: true

# Admin::ProofreadFormからWorkerを取得する
class WorkerFinder
  def find_by_proofread_form(proofread_form)
    worker_id = proofread_form.worker_id
    if worker_id == -1
      Worker.create(
        name_kana: proofread_form.worker_kana,
        name: proofread_form.worker_name,
        email: proofread_form.email,
        url: proofread_form.url
      )
    else
      Worker.find(worker_id)
    end
  end
end
