# frozen_string_literal: true

module Tramway
  module Forms
    # Provides method to determine decorators classes
    module ClassHelper
      module_function

      def form_class(object, form, namespace)
        object_class = object.class

        if form.present?
          form
        else
          klass_name = if namespace.present?
                         "#{namespace.to_s.camelize}::#{object_class}Form"
                       else
                         "#{object_class}Form"
                       end

          if klass_name.safe_constantize
            klass_name.constantize
          else
            raise "You should define #{klass_name} class in app/forms directory"
          end
        end
      end
    end
  end
end
