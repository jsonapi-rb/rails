class SerializableBook < JSONAPI::Serializable::Resource
  type 'books'

  link(:self) { @url_helpers.book_url(@object.id, host: 'api.example.com') }

  attribute :title

  has_one :author do
    link(:related) { @url_helpers.author_url(@object.author_id, host: 'api.example.com') }
    meta foo: 'bar'
  end

  has_one :series

  meta { Hash[foo: 'bar'] }
end
