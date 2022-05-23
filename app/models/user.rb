class User < ApplicationRecord
	has_many :emolevels

	validates :name, presence: true
    validates :telegram_id, presence: true
end
