# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProofreadForm do
  describe 'validations' do
    subject { ProofreadForm.new(proofread_form_params) }

    let(:work) { create(:work, :teihon, :with_person, work_status_id: 5, title: '作品その1') }
    let(:proofread_form_params) do
      {
        sub_works_attributes: {
          '0' => {
            work_id: work.id,
            enabled: 1
          }
        },
        person_id: work.people.first.id,
        worker_name: 'worker_name',
        worker_kana: 'worker_kana',
        email: 'test@example.com'
      }
    end

    it { is_expected.to be_valid }
  end

  describe '.new_by_author' do
    let(:person) { create(:person, last_name: '青空', first_name: '太郎', last_name_kana: 'あおぞら', first_name_kana: 'たろう', sortkey: 'あおぞら', sortkey2: 'たろう') }
    let(:work) { create(:work, :teihon, work_status_id: 5, title: '作品その1') }
    let(:work2) { create(:work, :teihon, work_status_id: 5, title: '作品その2') }

    before do
      create(:work_person, work:, person:)
      create(:work_person, work: work2, person:)
    end

    it 'personからProofreadFormを生成する' do
      form = ProofreadForm.new_by_author(person)

      expect(form.person_id).to eq(person.id)
      expect(form.sub_works.count).to eq(2)
      expect(form.sub_works[0].work_id).to eq(work.id)
      expect(form.sub_works[1].work_id).to eq(work2.id)
    end
  end
end
