class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def jsonapi_include
    params[:include]
  end

  def jsonapi_fields
    Hash[(params.to_unsafe_h[:fields] || {}).map { |k, v| [k, v.split(',')] }]
  end

  def jsonapi_links
    { root: 'http://api.example.com' }
  end

  def jsonapi_meta
    { foo: 'bar' }
  end
end
