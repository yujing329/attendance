class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # (1) への対応

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定の確認メールが送信されました。"
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスが見つかりません。"
      render 'new'
    end
  end

  def edit
  end

  def update  #12.16: パスワード再設定のupdateアクション
    if params[:user][:password].empty?                  # (3) への対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)          # (4) への対応
      log_in @user
      flash[:success] = "パスワードが更新されました！"
      redirect_to @user
    else
      render 'edit'                                     # (2) への対応
    end
  end
  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルタ

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 有効なユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
  
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "期限切れの為、パスワードのリセットが終了しました。"
        redirect_to new_password_reset_url
      end
    end
end