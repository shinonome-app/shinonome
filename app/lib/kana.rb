# frozen_string_literal: true

# Handling Kana characters and Kana columns
class Kana
  class Error < StandardError
  end

  ROMA2KANA_CHARS = { a: 'あいうえお',
                      ka: 'かきくけこ',
                      sa: 'さしすせそ',
                      ta: 'たちつてと',
                      na: 'なにぬねの',
                      ha: 'はひふへほ',
                      ma: 'まみむめも',
                      ya: 'やゆよ',
                      ra: 'らりるれろ',
                      wa: 'わをん',
                      zz: '' }.freeze

  ROMA2KANA = { a: 'あ', i: 'い', u: 'う', e: 'え', o: 'お',
                ka: 'か', ki: 'き', ku: 'く', ke: 'け', ko: 'こ',
                sa: 'さ', si: 'し', su: 'す', se: 'せ', so: 'そ',
                ta: 'た', ti: 'ち', tu: 'つ', te: 'て', to: 'と',
                na: 'な', ni: 'に', nu: 'ぬ', ne: 'ね', no: 'の',
                ha: 'は', hi: 'ひ', hu: 'ふ', he: 'へ', ho: 'ほ',
                ma: 'ま', mi: 'み', mu: 'む', me: 'め', mo: 'も',
                ya: 'や', yu: 'ゆ', yo: 'よ',
                ra: 'ら', ri: 'り', ru: 'る', re: 'れ', ro: 'ろ',
                wa: 'わ', wo: 'を', nn: 'ん',
                zz: nil }.freeze

  def self.from_kana(kana)
    sym = ROMA2KANA.invert[kana] || :zz
    new(sym)
  end

  def self.each_sym_and_char(&)
    ROMA2KANA.each_pair(&)
  end

  def self.each_column_key(&)
    ROMA2KANA_CHARS.each_key(&)
  end

  def self.each_column_chars
    ROMA2KANA_CHARS.each_value do |value|
      yield value.chars
    end
  end

  def initialize(roma_sym)
    @sym = roma_sym
    raise Kana::Error, "invalid symbol (#{@sym})" unless ROMA2KANA.keys.include?(@sym)
  end

  def to_chars
    raise Kana::Error, "invalid symbol (#{@sym})" unless ROMA2KANA_CHARS.keys.include?(@sym)

    ROMA2KANA_CHARS[@sym].chars
  end

  def to_char(other: nil)
    ROMA2KANA[@sym] || other
  end

  def to_symbol_and_index
    kana_char = to_char(other: 'not_found')
    ROMA2KANA_CHARS.each_pair do |roma, kana_str|
      idx = kana_str.index(kana_char)
      return roma, idx if idx
    end
    [:zz, 0]
  end
end
