class Book < ActiveRecord::Base

  has_and_belongs_to_many :authors

  has_one :page

  validates :title, presence: true

end
