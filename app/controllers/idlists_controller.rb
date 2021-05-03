# frozen_string_literal: true

class IdlistController < ApplicationController
  PERSON_ID_TABLE = [
    %w(あ い う え お),
    %w(か き く け こ),
    %w(さ し す せ そ),
    %w(た ち つ て と),
    %w(な に ぬ ね の),
    %w(は ひ ふ へ ほ),
    %w(ま み む め も),
    ['や', nil, 'ゆ', nil, 'よ'],
    %w(ら り る れ ろ),
    ['わ',nil,'を',nil,'ん'],
    
  ]
  def index; end
end
