class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) #8.7: ユーザーをデータベースから見つけて検証
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      # 9.23: [remember me] チェックボックスの送信結果を処理
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
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