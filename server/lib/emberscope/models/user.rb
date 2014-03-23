class User < ActiveRecord::Base
  before_create :set_uuid

  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :password

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  def set_uuid
    self.uuid ||= SecureRandom.hex(16)
  end

  def authenticate_password(pw)
    return false if pw.to_s == ""
    options = JSON.parse(self.password).merge(password: pw)
    hashed_password = options.delete("hashed_password")
    key = PBKDF2.new(options).hex_string
    key == hashed_password
  end

  def new_token
    salt = SecureRandom.hex(16)
    key  = "#{salt}:#{uuid}"
    salt + ":" + encryptor.encrypt_and_sign(key)
  end

  def authenticate_token(token)
    salt, message = token.split("-")
    result = encryptor.decrypt_and_verify(message)
    result == "#{salt}-#{uuid}"
  end

  SECRET = "23c$%!DX%$£TC£$ TB   $^T£QD$C%FDX$Q54F£%@£%%N&<Undo>B*IBRwetb57v45c$£v6£$V^C45wy6B $7w$%V@5vcfdxt£$^ n<F5>($)MM_l,)MK{_Wn6bV@V"

  def encryptor
    self.class.encryptor
  end

  def self.encryptor
    ActiveSupport::MessageEncryptor.new(SECRET)
  end

  def self.find_by_username_or_email(username_or_email)
    User.where(username: username_or_email).first ||
      User.where(email: username_or_email).first
  end

  def self.find_by_token(token)
    salt, message = *token.split(":")
    result = encryptor.decrypt_and_verify(message)
    _,  uuid = result.split(":")
    User.where(uuid: uuid).first
  rescue ActiveSupport::MessageVerifier::InvalidSignature => e
    return nil
  end

  def self.new_with_password(attributes, pw)
    attributes = attributes.clone
    attributes[:password] = User.hash_password(pw)
    User.new(attributes)
  end

  def self.hash_password(pw)
    return nil if pw == nil || pw.to_s == ""
    options = hashing_options.merge(password: pw)
    hashed_password = PBKDF2.new(options).hex_string
    options.delete(:password)
    options.merge(
      hashed_password: hashed_password
    ).to_json
  end

  def self.hashing_options
    {
      salt:          SecureRandom.hex(16), 
      iterations:    50000, 
      hash_function: "sha256"
    }
  end
end

class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :username, :email
  attribute :uuid, key: :id
end



