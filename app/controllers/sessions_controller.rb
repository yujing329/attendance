class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) #8.7: ユーザーをデータベースから見つけて検証
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      redirect_to user
    else
      #8.8: ログイン失敗時の処理を扱う (誤りあり)
      #flash[:danger] = 'Invalid email/password combination' # 本当は正しくない
      flash.now[:danger] = 'Invalid email/password combination' # 8.11: ログイン失敗時の正しい処理
      # エラーメッセージを作成する
      render 'new'
    end
  end

  def destroy
    log_out  #8.30: セッションを破棄する (ユーザーのログアウト)
    redirect_to root_url
  end
end