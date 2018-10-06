class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index   #10.35: indexアクションにはログインを要求
    @users = User.paginate(page: params[:page])   #10.46: indexアクションでUsersをページネート
  end

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
      log_in @user        #8.25: ユーザー登録中にログイン
      flash[:success] = "Welcome to the Sample App!"   #7.29: ユーザー登録ページにフラッシュメッセージを追加
      redirect_to @user   #7.28: 保存とリダイレクトを行う、userのcreateアクション
    else
      render 'new'
    end
  end

  def edit    #10.1: ユーザーのeditアクション
    @user = User.find(params[:id])
  end

  def update  #10.8: ユーザーのupdateアクションの初期実装
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy   #10.58: 実際に動作するdestroyアクションを追加
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private   #7.19: createアクションでStrong Parametersを使う

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # beforeアクション

  # ログイン済みユーザーかどうか確認
  def logged_in_user    #10.15: beforeフィルターにlogged_in_userを追加
    unless logged_in?
    store_location      #10.31: ログインユーザー用beforeフィルターにstore_locationを追加
    flash[:danger] = "Please log in."
    redirect_to login_url
    end
  end
  
  # 正しいユーザーかどうか確認
  def correct_user    #10.25: beforeフィルターを使って編集/更新ページを保護
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # 管理者かどうか確認
  def admin_user      #10.59: beforeフィルターでdestroyアクションを管理者だけに限定
    redirect_to(root_url) unless current_user.admin?
  end
end
