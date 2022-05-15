# frozen_string_literal: true

# 50音検索用
class SyllabaryTableComponent < ViewComponent::Base
  TABLES = [
    [
      %i[a i u e o],
      %i[ka ki ku ke ko],
      %i[sa si su se so],
      %i[ta ti tu te to],
      %i[na ni nu ne no],
      %i[ha hi hu he ho],
      %i[ma mi mu me mo],
      [:ya, nil, :yu, nil, :yo],
      %i[ra ri ru re ro],
      [:wa, :wo, :nn, nil, nil]
    ]
  ].freeze

  attr_reader :key

  def initialize(key:)
    super
    @key = key
  end
end
