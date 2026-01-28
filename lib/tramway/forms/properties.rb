# frozen_string_literal: true

module Tramway
  module Forms
    # This is `properties`. The main feature of Tramway Form
    module Properties
      # A collection of methods that would be using in users forms
      module ClassMethods
        def property(attribute)
          if attribute.to_sym == :fields
            raise ArgumentError, "You should not use name `fields` as property name"
          end

          @properties << attribute

          define_method(attribute) do
            raise NoMethodError, "#{self.class}##{attribute} is not defined" unless object.respond_to?(attribute)

            object.public_send(attribute)
          end

          set_method = "#{attribute}="

          define_method(set_method) do |value|
            raise NoMethodError, "#{self.class}##{set_method} is not defined" unless object.respond_to?(set_method)

            object.public_send(set_method, value)
          end
        end

        def properties(*attributes)
          attributes.any? ? __set_properties(attributes) : __properties
        end

        def __set_properties(attributes)
          attributes.each do |attribute|
            property(attribute)
          end
        end

        def __properties
          (__ancestor_properties + @properties).uniq
        end

        def __ancestor_properties(klass = superclass)
          superklass = klass.superclass

          return [] unless superklass.respond_to?(:properties)

          klass.properties + __ancestor_properties(superklass)
        end

        def __initialize_properties(subclass)
          subclass.instance_variable_set(:@properties, [])
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      def __apply_properties(params)
        self.class.properties.each do |attribute|
          public_send("#{attribute}=", params[attribute]) if params.key?(attribute)
        end
      end
    end
  end
end
