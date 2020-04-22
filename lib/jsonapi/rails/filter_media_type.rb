require 'rack/media_type'

module JSONAPI
  module Rails
    class FilterMediaType
      JSONAPI_MEDIA_TYPE = 'application/vnd.api+json'.freeze

      def initialize(app)
        @app = app
      end

      def call(env)
        return [415, {}, []] unless valid_content_type?(env['CONTENT_TYPE'])
        return [406, {}, []] unless valid_accept?(env['HTTP_ACCEPT'])

        @app.call(env)
      end

      private

      def valid_content_type?(content_type)
        Rack::MediaType.type(content_type) != JSONAPI_MEDIA_TYPE ||
          Rack::MediaType.params(content_type).empty?
      end

      def valid_accept?(accept)
        return true if accept.nil?

        jsonapi_media_types =
          accept.split(',')
                .map(&:strip)
                .select { |m| Rack::MediaType.type(m) == JSONAPI_MEDIA_TYPE }

        jsonapi_media_types.empty? ||
          jsonapi_media_types.any? { |m| Rack::MediaType.params(m).empty? }
      end
    end
  end
end
