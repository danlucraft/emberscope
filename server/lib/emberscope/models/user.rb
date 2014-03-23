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

  def authenticate(pw)
    return false if pw.to_s == ""
    options = JSON.parse(self.password).merge(password: pw)
    hashed_password = options.delete("hashed_password")
    key = PBKDF2.new(options).hex_string
    key == hashed_password
  end

  def self.find_by_username_or_email(username_or_email)
    User.where(username: username_or_email).first ||
      User.where(email: username_or_email).first
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



