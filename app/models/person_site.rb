# frozen_string_literal: true

# == Schema Information
#
# Table name: person_sites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint           not null
#  site_id    :bigint           not null
#
# Indexes
#
#  index_person_sites_on_person_id              (person_id)
#  index_person_sites_on_person_id_and_site_id  (person_id,site_id) UNIQUE
#  index_person_sites_on_site_id                (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (site_id => sites.id)
#

# 作者・貢献者
class PersonSite < ApplicationRecord
  belongs_to :person
  belongs_to :site

  validates :person_id, uniqueness: { scope: :site_id, message: 'がすでに関連付けられています' }

  def self.csv_header
    "人物id,姓,姓読み,姓英字,名,名読み,名英字,生年月日,没年月日,著作権フラグ,関連サイトid,関連サイト名,関連サイトurl,関連サイト運営者名,email,備考\r\n"
  end

  def to_csv
    array = [person.id, person.last_name, person.last_name_kana, person.last_name_en, person.first_name, person.first_name_kana, person.first_name_en, person.born_on, person.died_on, person.copyright_char]

    sites_array = if person.person_sites.first.present?
                    [site.id, site.name, site.url, site.owner_name, site.email, site.note]
                  else
                    ['', '', '', '', '', '', '']
                  end
    array += sites_array

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end
end
