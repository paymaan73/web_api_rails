class Publisher < ApplicationRecord
  has_many :books

  validates :name, presence: true
end
