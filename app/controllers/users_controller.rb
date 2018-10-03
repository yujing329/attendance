class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new   #7.14: newアクションに@user変数を追加
  end
  
  def create   #7.18: ユーザー登録の失敗に対応できるcreateアクション
    @user = User.new(user_params)
    if @user.save
      # 保存の成功をここで扱う
      log_in @user #8.25: ユーザー登録中にログイン
      flash[:success] = "Welcome to the Sample App!"   #7.29: ユーザー登録ページにフラッシュメッセージを追加
      redirect_to @user   #7.28: 保存とリダイレクトを行う、userのcreateアクション
    else
      render 'new'
    end
  end

  private   #7.19: createアクションでStrong Parametersを使う

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
