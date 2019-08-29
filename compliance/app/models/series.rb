class Series < ActiveRecord::Base
  has_many :books
  belongs_to :photo
end
