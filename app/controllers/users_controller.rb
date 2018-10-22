class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new   #7.14: newアクションに@user変数を追加
  end
  
  def create   #7.18: ユーザー登録の失敗に対応できるcreateアクション
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールを確認してアカウントを有効にしてください。"
      redirect_to root_url
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

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # beforeフィルター

  # 正しいユーザーかどうかを確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうかを確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end