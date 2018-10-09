module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)  #8.14: log_inメソッド
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)  #9.8: ユーザーを記憶
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)   #10.27: current_user?メソッド
    user == current_user
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user #9.9: 永続的セッションのcurrent_userを更新
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?  #8.18: logged_in?ヘルパーメソッド
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)  #9.12: 永続セッションからログアウト
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out  #8.29: log_outメソッド
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 10.30: フレンドリーフォワーディングの実装
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end