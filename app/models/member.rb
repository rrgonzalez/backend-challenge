class Member
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :website_url, type: String
  field :website_short_url, type: String

  has_many :headings
  has_and_belongs_to_many :friends,
                          class_name: :Member
end
