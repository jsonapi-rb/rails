require 'rails_helper'

describe ActionController::Base, '#render', type: :controller do
  with_model :User, scope: :all do
    table do |t|
      t.string :name
      t.string :email
    end

    model do
      validates :name, presence: true
      validates :email, format: { with: /@/, message: 'must be a valid email' }
    end
  end

  let(:serialized_errors) do
    {
      'errors' => [
        {
          'code' => 'blank',
          'detail' => 'Name can\'t be blank',
          'title' => 'Invalid name',
          'source' => { 'pointer' => '/data/attributes/name' }
        },
        {
          'code' => 'invalid',
          'detail' => 'Email must be a valid email',
          'title' => 'Invalid email',
          'source' => { 'pointer' => '/data/attributes/email' }
        }
      ],
      'jsonapi' => { 'version' => '1.0' }
    }
  end

  context 'when rendering ActiveModel::Errors' do
    controller do
      def create
        user = User.new(email: 'lucas')

        unless user.valid?
          render jsonapi_errors: user.errors
        end
      end

      def jsonapi_pointers
        {
          name: '/data/attributes/name',
          email: '/data/attributes/email'
        }
      end
    end

    subject { JSON.parse(response.body) }

    it 'renders a JSON API error document' do
      post :create

      expect(response.content_type).to eq('application/vnd.api+json')
      is_expected.to eq(serialized_errors)
    end
  end

  context 'when rendering error hashes' do
    controller do
      def create
        errors = [
          {
            'code' => 'blank',
            detail: 'Name can\'t be blank',
            title: 'Invalid name',
            source: { pointer: '/data/attributes/name' }
          },
          {
            'code' => 'invalid',
            detail: 'Email must be a valid email',
            title: 'Invalid email',
            source: { pointer: '/data/attributes/email' }
          }
        ]

        render jsonapi_errors: errors
      end
    end

    subject { JSON.parse(response.body) }

    it 'renders a JSON API error document' do
      post :create

      expect(response.content_type).to eq('application/vnd.api+json')
      is_expected.to eq(serialized_errors)
    end
  end
end
