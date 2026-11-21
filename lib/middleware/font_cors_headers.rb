# frozen_string_literal: true

module Middleware
  # フォントのレスポンスに Access-Control-Allow-Origin: * を付ける。
  #
  # 公開サイトのプレビュー（SandboxedPreview）は CSP の sandbox で opaque origin になるため、
  # そこから読む /assets のフォントは別オリジンへのリクエストになり、CORS ヘッダがないと拒否される。
  # フォントは公開してよい静的ファイルなので、オリジンを限定しない。
  #
  # 本番は ActionDispatch::Static、開発は Propshaft::Server がフォントを返すので、その両方の手前に置く。
  class FontCorsHeaders
    FONT_PATH = /\.(?:woff2?|ttf|otf)\z/

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers['access-control-allow-origin'] = '*' if env['PATH_INFO'].to_s.match?(FONT_PATH)
      [status, headers, body]
    end
  end
end
