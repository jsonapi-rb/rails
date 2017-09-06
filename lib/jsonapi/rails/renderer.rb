require 'jsonapi/rails/serializable_active_model_errors'
require 'jsonapi/rails/serializable_error_hash'
require 'jsonapi/serializable/renderer'

module JSONAPI
  module Rails
    DEFAULT_INFERRER = Hash.new do |h, k|
      names = k.to_s.split('::')
      klass = names.pop
      h[k] = [*names, "Serializable#{klass}"].join('::').safe_constantize
    end

    class SuccessRenderer
      def initialize(renderer = JSONAPI::Serializable::Renderer.new)
        @renderer = renderer

        freeze
      end

      def render(resources, options, controller)
        options = default_options(options, controller, resources)

        @renderer.render(resources, options)
      end

      private

      # @api private
      def default_options(options, controller, resources)
        options.dup.tap do |opts|
          opts[:class] ||= DEFAULT_INFERRER
          if (pagination_links = controller.jsonapi_pagination(resources))
            (opts[:links] ||= {}).merge!(pagination_links)
          end
          opts[:expose]  = controller.jsonapi_expose.merge!(opts[:expose] || {})
          opts[:jsonapi] = opts[:jsonapi_object] || controller.jsonapi_object
        end
      end
    end

    class ErrorsRenderer
      def initialize(renderer = JSONAPI::Serializable::Renderer.new)
        @renderer = renderer

        freeze
      end

      def render(errors, options, controller)
        options = default_options(options, controller)

        errors = [errors] unless errors.is_a?(Array)

        @renderer.render_errors(errors, options)
      end

      private

      # @api private
      def default_options(options, controller)
        options.dup.tap do |opts|
          # TODO(lucas): Make this configurable.
          opts[:class] ||= DEFAULT_INFERRER
          unless opts[:class].key?(:'ActiveModel::Errors')
            opts[:class][:'ActiveModel::Errors'] =
              JSONAPI::Rails::SerializableActiveModelErrors
          end
          unless opts[:class].key?(:Hash)
            opts[:class][:Hash] = JSONAPI::Rails::SerializableErrorHash
          end
          opts[:expose] =
            controller.jsonapi_expose
              .merge!(opts[:expose] || {})
              .merge!(_jsonapi_pointers: controller.jsonapi_pointers)
          opts[:jsonapi] = opts[:jsonapi_object] || controller.jsonapi_object
        end
      end
    end
  end
end
