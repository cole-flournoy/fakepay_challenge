class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :plan, :addr_one, :addr_two, :city, :state, :zip, :created_at
  belongs_to :customer
end
