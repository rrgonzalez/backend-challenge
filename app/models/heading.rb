class Heading
  include Mongoid::Document
  include Mongoid::Timestamps

  field :pretty_print, type: String
  field :hashed_terms, type: Set
end
