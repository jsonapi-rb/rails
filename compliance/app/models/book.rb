class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :series
  has_many :chapters
  has_and_belongs_to_many :stores
end
