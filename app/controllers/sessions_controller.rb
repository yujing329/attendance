class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) #8.7: ユーザーをデータベースから見つけて検証
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination' # 8.11: ログイン失敗時の正しい処理
      # エラーメッセージを作成する
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?  #9.16: ログイン中の場合のみログアウト
    redirect_to root_url
  end
end