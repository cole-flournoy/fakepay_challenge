class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :subscriptions
  has_many :subscriptions
end
