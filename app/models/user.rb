class User < ApplicationRecord
  attr_accessor :remember_token
  #before_save { self.email = email.downcase }  #6.32: email属性を小文字に変換してメールアドレスの一意性を保証
  before_save { email.downcase! }               #6.34: もう１つのコールバック処理の実装方法
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },  #6.21: メールフォーマットを正規表現で検証
                    uniqueness: { case_sensitive: false }   #6.27: メールアドレスの大文字小文字を無視した一意性の検証
  has_secure_password  #リスト 6.37
  validates :password, presence: true, length: { minimum: 6 }  #6.42: 

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)  #8.21: fixture向けのdigestメソッドを追加
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token # 9.2: トークン生成用メソッド
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember #9.3: rememberメソッドをUserモデルに追加
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)  #9.6: authenticated?をUserモデルに追加
    return false if remember_digest.nil?  #9.19: authenticated?を更新して、ダイジェストが存在しない場合に対応
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget #9.11: forgetメソッドをUserモデルに追加
    update_attribute(:remember_digest, nil)
  end

end