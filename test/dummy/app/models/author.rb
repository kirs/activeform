class Author < ActiveRecord::Base
      #belongs_to :user
  has_and_belongs_to_many :books
  #     # validates :twitter_name, :github_name, uniqueness: true
  #     end
  #
  #

end
