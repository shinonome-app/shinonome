# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminMailSender do
  let(:service) { AdminMailSender.new }

  describe '#send' do
    subject(:result) { service.send(admin_mail_params) }

    let(:cc_flag) { 0 }
    let(:mail_subject) { 'test' }
    let(:body) { 'this is test mail.' }
    let(:admin_mail_params) do
      { worker_id:, email:, subject: mail_subject, cc_flag:, body: }
    end

    context 'メールアドレスがadmin_mail_paramsに渡っている場合' do
      let(:email) { 'test@example.com' }
      let(:worker_id) { 12345 }

      context 'AdminMailSecret の保存が成功する場合' do
        before do
          perform_enqueued_jobs do
            result
          end
        end

        it 'メールは送信される' do
          expect(ActionMailer::Base.deliveries.size).to eq(1)
        end

        it '戻り値の sent? が true になる' do
          expect(result.sent?).to eq true
        end

        it '戻り値の admin_mail_secret に作成されたAdminMailSecretオブジェクトが設定される' do
          expect(result.admin_mail_secret).to be_a(AdminMailSecret)
          expect(result.admin_mail_secret.email).to eq 'test@example.com'
        end
      end

      context 'AdminMailSecret の保存が失敗する場合' do
        let(:body) { '' }

        before do
          perform_enqueued_jobs do
            result
          end
        end

        it 'メールは送信されない' do
          expect(ActionMailer::Base.deliveries.size).to eq(0)
        end

        it '戻り値の sent? が false になる' do
          expect(result.sent?).to eq false
        end
      end
    end

    context 'メールアドレスがないが、指定したworker_idのworkerが存在する場合' do
      let(:email) { nil }
      let(:worker_id) { worker.id }
      let(:worker) do
        create(:worker) { |worker| create(:worker_secret, worker:) }
      end

      context 'AdminMailSecret の保存が成功する場合' do
        before do
          perform_enqueued_jobs do
            result
          end
        end

        it 'メールは送信される' do
          expect(ActionMailer::Base.deliveries.size).to eq(1)
        end

        it 'Shinonome::WorkerSecret からメールを補完する' do
          worker_secret = Shinonome::WorkerSecret.find_by(worker_id: worker.id)
          expect(result.admin_mail_secret.email).to eq worker_secret.email
        end

        it 'sent? が true になる' do
          expect(result.sent?).to eq true
        end
      end

      context 'AdminMailSecret の保存が失敗する場合' do
        let(:body) { '' }

        before do
          perform_enqueued_jobs do
            result
          end
        end

        it 'メールは送信されない' do
          expect(ActionMailer::Base.deliveries.size).to eq(0)
        end

        it 'sent? が false になる' do
          expect(result.sent?).to eq false
        end
      end

      context 'Shinonome::WorkerSecret が見つからない場合' do
        let(:worker_id) { -1 }

        before do
          perform_enqueued_jobs do
            result
          end
        end

        it 'メールは送信されない' do
          expect(ActionMailer::Base.deliveries.size).to eq(0)
        end

        it 'email は補完されないので nil のまま' do
          expect(result.admin_mail_secret.email).to be_nil
        end
      end
    end

    context 'メールアドレスも worker_id も存在しない場合' do
      let(:email) { nil }
      let(:worker_id) { nil }
      let(:body) { '' }

      before do
        perform_enqueued_jobs do
          result
        end
      end

      it 'メールは送信されない' do
        expect(ActionMailer::Base.deliveries.size).to eq(0)
      end

      it 'AdminMailSecret を作成するとき email は空のまま' do
        expect(result.admin_mail_secret.email).to be_nil
      end

      it 'sent? が true になる' do
        expect(result.sent?).to eq false
      end
    end
  end
end
