class Page < ActiveRecord::Base
  belongs_to :book

  validates :title, presence: true
end
