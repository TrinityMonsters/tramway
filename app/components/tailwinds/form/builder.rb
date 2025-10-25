# frozen_string_literal: true

module Tailwinds
  module Form
    # Provides Tailwind-styled forms
    # :reek:InstanceVariableAssumption
    class Builder < Tramway::Views::FormBuilder
      def initialize(object_name, object, template, options)
        super

        @form_size = options[:size] || options['size'] || :middle
      end

      def common_field(component_name, input_method, attribute, **options, &)
        sanitized_options = sanitize_options(options)

        component_class = "Tailwinds::Form::#{component_name.to_s.camelize}FieldComponent".constantize

        render(new(component_class,
                   input: input(input_method),
                   value: get_value(attribute, sanitized_options),
                   **default_options(attribute, sanitized_options)), &)
      end

      def text_field(attribute, **, &)
        common_field(:text, :text_field, attribute, **, &)
      end

      def email_field(attribute, **, &)
        common_field(:text, :email_field, attribute, **, &)
      end

      def number_field(attribute, **, &)
        common_field(:number, :number_field, attribute, **, &)
      end

      def text_area(attribute, **, &)
        common_field(:text_area, :text_area, attribute, **, &)
      end

      def password_field(attribute, **options, &)
        sanitized_options = sanitize_options(options)

        render(Tailwinds::Form::TextFieldComponent.new(
                 input: input(:password_field),
                 **default_options(attribute, sanitized_options)
               ), &)
      end

      def file_field(attribute, **options, &)
        sanitized_options = sanitize_options(options)
        input = super(attribute, **sanitized_options.merge(class: :hidden))

        render(Tailwinds::Form::FileFieldComponent.new(input:, **default_options(attribute, sanitized_options)), &)
      end

      def select(attribute, collection, **options, &)
        sanitized_options = sanitize_options(options)

        render(Tailwinds::Form::SelectComponent.new(
                 input: input(:select),
                 value: sanitized_options[:selected] || object.public_send(attribute),
                 collection: explicitly_add_blank_option(collection, sanitized_options),
                 **default_options(attribute, sanitized_options)
               ), &)
      end

      def multiselect(attribute, collection, **options, &)
        sanitized_options = sanitize_options(options)

        render(Tailwinds::Form::MultiselectComponent.new(
                 input: input(:text_field),
                 value: sanitized_options[:value] || sanitized_options[:selected] || object.public_send(attribute),
                 collection:,
                 **default_options(attribute, sanitized_options)
               ), &)
      end

      def submit(action, **options, &)
        sanitized_options = sanitize_options(options)

        render(Tailwinds::Form::SubmitButtonComponent.new(action, size: form_size, **sanitized_options), &)
      end

      private

      attr_reader :form_size

      def input(method_name)
        unbound_method = self.class.superclass.instance_method(method_name)
        unbound_method.bind(self)
      end

      def get_value(attribute, options)
        options[:value] || (object.present? ? object.public_send(attribute) : nil)
      end

      def default_options(attribute, options)
        { attribute:, label: label_build(attribute, options), for: for_id(attribute), options:, size: form_size }
      end

      # :reek:UtilityFunction
      # :reek:NilCheck
      def label_build(attribute, options)
        label_option = options[:label]

        label_option.nil? ? attribute.to_s.humanize : label_option
      end

      def for_id(attribute)
        "#{object_name}_#{attribute}"
      end

      def sanitize_options(options)
        options.dup.tap do |opts|
          opts.delete(:size)
          opts.delete('size')
        end
      end

      # REMOVE IT. WE MUST UNDERSTAND WHY INCLUDE_BLANK DOES NOT WORK
      # :reek:UtilityFunction
      def explicitly_add_blank_option(collection, options)
        if options[:include_blank]
          collection = collection.to_a if collection.is_a? Hash

          collection.unshift([nil, ''])
        else
          collection
        end
      end
    end
  end
end
