# frozen_string_literal: true

module Tramway
  module Decorators
    # Provides method to determine decorators classes
    module ClassHelper
      module_function

      def decorator_class(object_or_array, decorator = nil, namespace = nil)
        raise_error_if_object_empty object_or_array, decorator

        return decorator if decorator.present?

        begin
          class_name = decorator_class_name(object_or_array, namespace)
          class_name.constantize
        rescue NameError
          raise NameError, "You should define #{class_name} decorator class."
        end
      end

      def decorator_class_name(object_or_array_or_class, namespace)
        klass = if Tramway::Decorators::CollectionDecorators.collection?(object_or_array_or_class)
                  object_or_array_or_class.first.class
                elsif object_or_array_or_class.is_a?(Class)
                  object_or_array_or_class
                else
                  object_or_array_or_class.class
                end

        base_class_name = Tramway::Decorators::NameBuilder.default_decorator_class_name(klass)

        klass_name = namespace.present? ? "#{namespace.to_s.camelize}::#{base_class_name}" : base_class_name

        if klass_name.safe_constantize
          klass_name
        else
          raise NameError, "You should define #{klass_name} decorator class in app/decorators/ folder."
        end
      end

      # :reek:NilCheck { enabled: false }
      def raise_error_if_object_empty(object_or_array, decorator)
        return unless object_or_array.blank? && decorator.nil?

        text = 'You should pass object or array that is not empty OR provide a decorator class as a second argument'

        raise ArgumentError, text
      end
      # :reek:NilCheck { enabled: true }
    end
  end
end
