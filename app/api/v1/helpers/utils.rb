# frozen_string_literal: true

module V1
  module Helpers
    module Utils
      extend Grape::API::Helpers

      def render_error(code: 422, message: '', data: nil)
        status code
        { success: false, message: message, data: data }
      end

      def render_success(code: 200, message: '', data: nil)
        status code
        { success: true, message: message, data: data }
      end

      def deny_access
        error!({ message: 'Not Authorized' }, 401)
      end

      def rack_code(symbol)
        Rack::Utils::SYMBOL_TO_STATUS_CODE[symbol.to_sym]
      end

      def serialized_data(object, serializer_class=nil)
        return unless object.present?
        
        serializer_class ||= if object.respond_to?(:to_a)
          "#{object[0].class}Serializer".constantize
        else
          "#{object.class}Serializer".constantize
        end
        
        if object.respond_to?(:to_a)
          object.map { |o|  serializer_class.new(o).serializable_hash.dig(:data, :attributes)}
        else
          serializer_class.new(object).serializable_hash.dig(:data, :attributes)
        end
      end

      params :pagination do
        optional :page, type: Integer, default: 1, allow_blank: false, values: ->(v) { v.positive? }
        optional :per_page, type: Integer, default: 20, allow_blank: false, values: ->(v) { v.positive? }
      end
    end
  end
end
