class User
  include Dynamoid::Document

  table :name => :awesome_users, :key => :user_id, :read_capacity => 400, :write_capacity => 400
  field :name
  field :email
  field :rank, :integer
  field :number, :number
  field :joined_at, :datetime
  field :hash, :serialized

end
