# frozen_string_literal: true

# == Schema Information
#
# Table name: base_people
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  original_person_id :bigint           not null
#  person_id          :bigint           not null
#
# Indexes
#
#  index_base_people_on_original_person_id  (original_person_id)
#  index_base_people_on_person_id           (person_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (original_person_id => people.id)
#  fk_rails_...  (person_id => people.id)
#

require 'rails_helper'

RSpec.describe BasePerson, type: :model do
  describe 'validation' do
    let (:base_person) { create(:base_person) }
    let (:person) { create(:person) }

    it 'person_idが重複したらエラーになる' do
      person2 = base_person.person
      expect { BasePerson.create!(person_id: person2.id, original_person_id: person.id) }.to raise_error(ActiveRecord::RecordInvalid, 'バリデーションに失敗しました: 人物IDがすでに他の基本人物に関連付けられています')
    end

    it 'person_idとoriginal_person_idが重複したらエラーになる' do
      expect { BasePerson.create!(person_id: person.id, original_person_id: person.id) }.to raise_error(ActiveRecord::RecordInvalid, 'バリデーションに失敗しました: 人物IDが基本人物IDと重複しています')
    end
  end
end
