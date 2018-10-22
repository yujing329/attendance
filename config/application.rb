require File.expand_path('../boot', __FILE__)
require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    config.load_defaults 5.1

    # 認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.assets.initialize_on_precompile = false
    #config.i18n.default_locale = :ja # デフォルトのlocaleを日本語(:ja)にする
    #config/localse以下のファイルを読み込む
    #config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
