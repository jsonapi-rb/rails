module JSONAPI
  module Rails
    # @private
    class SerializableActiveModelError < Serializable::Error
      title do
        "Invalid #{@field}" unless @field.nil?
      end

      detail do
        @message
      end

      source do
        pointer @pointer unless @pointer.nil?
      end
    end

    # @private
    class SerializableActiveModelErrors
      def initialize(exposures)
        @errors = exposures[:object]
        @reverse_mapping = exposures[:_jsonapi_pointers] || {}

        freeze
      end

      def as_jsonapi
        error_keys.flat_map do |key|
          @errors.full_messages_for(key).map do |message|
            SerializableActiveModelError.new(field: key, message: message,
                                             pointer: @reverse_mapping[key])
              .as_jsonapi
          end
        end
      end

      private

      def error_keys
        @errors.respond_to?(:attribute_names) ? @errors.attribute_names : @errors.keys
      end
    end
  end
end
