class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :token
  has_many :subscriptions
end
