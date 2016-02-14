class User < ActiveRecord::Base
  has_many :costs, dependent: :destroy
end
