# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpUrlValidator do
  let(:model_class) do
    Class.new do
      include ActiveModel::Model
      include ActiveModel::Attributes

      def self.name = 'HttpUrlTestModel'

      attribute :url, :string

      def url=(value)
        super(HttpUrlValidator.normalize(value))
      end

      validates :url, http_url: true
    end
  end

  def valid_url?(url)
    model_class.new(url:).valid?
  end

  it 'accepts http and https URLs' do
    expect(valid_url?('http://example.com/')).to be true
    expect(valid_url?('https://example.com/path?q=1#top')).to be true
    expect(valid_url?('HTTPS://EXAMPLE.COM/')).to be true
  end

  it 'accepts URLs with Japanese characters' do
    expect(valid_url?('https://ja.wikipedia.org/wiki/夏目漱石')).to be true
    expect(valid_url?('https://日本語.jp/')).to be true
  end

  it 'accepts blank values' do
    expect(valid_url?('')).to be true
    expect(valid_url?(nil)).to be true
  end

  it 'strips surrounding spaces including full-width ones' do
    record = model_class.new(url: " \thttps://example.com/　\n")
    expect(record.url).to eq('https://example.com/')
    expect(record).to be_valid
  end

  it 'rejects other schemes' do
    expect(valid_url?('javascript:alert(1)')).to be false
    expect(valid_url?('ftp://example.com/')).to be false
    expect(valid_url?('example.com')).to be false
  end

  it 'rejects values that only contain an http URL in the middle' do
    expect(valid_url?('javascript:alert(1)//https://example.com/')).to be false
  end

  it 'rejects spaces, control characters and HTML-significant characters inside the URL' do
    ['https://example.com/a b', 'https://example.com/　x', "https://example.com/\nx",
     'https://example.com/"onmouseover="alert(1)', "https://example.com/'x", 'https://example.com/<x>'].each do |url|
      expect(valid_url?(url)).to be(false), url.inspect
    end
  end

  it 'adds the error message' do
    record = model_class.new(url: 'javascript:alert(1)')
    record.valid?
    expect(record.errors[:url]).to include('はhttp:またはhttps:で始まるURLを入力してください')
  end
end
