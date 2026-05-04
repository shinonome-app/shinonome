# frozen_string_literal: true

module NatsuzoraContext
  # Builds the context hash for people/show.ntzr (作家別作品リスト).
  class PersonBuilder
    def initialize(person)
      @person = person
    end

    def build
      bgcolor = @person.copyright? ? 'bg-rose-50' : 'bg-sky-50'
      kana_sym, kana_index = compute_kana_fragment

      {
        'page_title' => "作家別作品リスト：#{@person.name} | 青空文庫",
        'bgcolor' => bgcolor,
        'person_id' => @person.id,
        'last_name' => @person.last_name,
        'first_name' => @person.first_name.to_s,
        'full_name' => @person.name,
        'full_name_kana' => @person.name_kana,
        'last_name_kana' => @person.last_name_kana,
        'first_name_kana' => @person.first_name_kana.to_s,
        'name_en' => @person.name_en.to_s,
        'born_on' => @person.born_on.to_s,
        'died_on' => @person.died_on.to_s,
        'copyright_flag' => @person.copyright_flag,
        'description' => @person.description.to_s,
        'kana' => kana_sym.to_s,
        'kana_fragment' => "sec#{kana_index + 1}",
        'other_base_people' => build_other_base_people,
        'works' => build_works(@person.published_works),
        'has_unpublished_works' => @person.unpublished_works.exists?,
        'unpublished_works' => build_works(@person.unpublished_works),
        'sites' => build_sites
      }
    end

    private

    def compute_kana_fragment
      first_char = @person.sortkey&.first
      return [:zz, 0] if first_char.blank?

      kana = Kana.from_kana(first_char)
      kana.to_symbol_and_index
    end

    def build_works(works_scope)
      works_scope.includes(:work_people, work_people: [:person, :role]).map do |work|
        first_author = work.work_people.find { |wp| wp.role_id == 1 }&.person
        card_person_id = first_author ? format('%06d', first_author.id) : ''
        role_wp = work.work_people.find { |wp| wp.person_id == @person.id }

        {
          'id' => work.id,
          'title' => work.title,
          'title_kana' => work.title_kana.to_s,
          'subtitle' => work.subtitle.to_s,
          'role' => role_wp&.role&.name.to_s,
          'role_id' => role_wp&.role_id,
          'kana_type' => work.kana_type&.name.to_s,
          'card_person_id' => card_person_id,
          'work_people' => work.work_people.map do |wp|
            {
              'person_id' => wp.person_id,
              'name' => wp.person.name,
              'role_name' => wp.role&.name.to_s
            }
          end
        }
      end
    end

    def build_other_base_people
      @person.other_base_people.map do |p|
        { 'id' => p.id, 'name' => p.name }
      end
    end

    def build_sites
      @person.sites.map do |s|
        { 'name' => s.name.to_s, 'url' => s.url.to_s }
      end
    end
  end
end
