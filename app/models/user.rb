class User < ApplicationRecord
  #before_save { self.email = email.downcase }  #6.32: email属性を小文字に変換してメールアドレスの一意性を保証
  before_save { email.downcase! }               #6.34: もう１つのコールバック処理の実装方法
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },  #6.21: メールフォーマットを正規表現で検証
                    uniqueness: { case_sensitive: false }   #6.27: メールアドレスの大文字小文字を無視した一意性の検証
  has_secure_password  #リスト 6.37
  validates :password, presence: true, length: { minimum: 6 }  #6.42: セキュアパスワードの完全な実装
end