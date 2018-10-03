module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)  #8.14: log_inメソッド
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?  #8.18: logged_in?ヘルパーメソッド
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out  #8.29: log_outメソッド
    session.delete(:user_id)
    @current_user = nil
  end

end