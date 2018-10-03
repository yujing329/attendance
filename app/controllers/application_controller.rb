class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper  #8.13: ApplicationコントローラにSessionヘルパーモジュールを読み込む
  def hello
    render html: "hello, world!"
  end
end