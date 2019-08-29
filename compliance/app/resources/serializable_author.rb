class SerializableAuthor < JSONAPI::Serializable::Resource
  type 'authors'

  attributes :name, :date_of_birth, :date_of_death

  has_one :books
end
