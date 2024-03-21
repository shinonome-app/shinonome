# frozen_string_literal: true

# Admin::ProofreadFormからWorkerを取得する
class WorkerFinder
  def find_with_form(form)
    worker_id = form.worker_id
    if worker_id == -1
      Worker.create!(
        name_kana: form.worker_kana,
        name: form.worker_name,
        worker_secret_attributes: {
          email: form.email,
          url: form.url
        }
      )
    else
      Worker.find(worker_id)
    end
  end
end
