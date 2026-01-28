# frozen_string_literal: true

module Tailwinds
  module Form
    # Tailwind-styled multi-select field
    class MultiselectComponent < TailwindComponent
      option :collection

      def before_render
        @collection = collection.map do |(text, value)|
          { text:, value: }
        end.to_json
      end

      def multiselect_hash
        {
          controller:,
          selected_item_template:,
          multiselect_selected_items_value:,
          dropdown_container:,
          item_container:,
          items:,
          action:,
          select_as_input:,
          placeholder:,
          value:,
          on_change:
        }.transform_keys { |key| key.to_s.gsub('_', '-') }
      end

      def controller
        controllers = [:multiselect]
        controllers << external_action.split('->').last.split('#').first if external_action
        controllers += external_controllers
        controllers.join(' ')
      end

      private

      def action
        'click->multiselect#toggleDropdown'
      end

      def items
        collection
      end

      def placeholder
        options[:placeholder]
      end

      def multiselect_selected_items_value
        []
      end

      def select_as_input
        component(
          'tailwinds/form/multiselect/select_as_input',
          options:,
          attribute:,
          input:,
          size_class: size_class(:multiselect_input)
        )
      end

      def on_change
        return unless external_action&.start_with?('change')

        external_action.split('->').last
      end

      def external_controllers
        options[:controller]&.split || []
      end

      def external_action
        options.dig(:data, :action)
      end

      def selected_item_template
        component('tailwinds/form/multiselect/selected_item_template', size:)
      end

      def dropdown_container
        component('tailwinds/form/multiselect/dropdown_container', size:)
      end

      def item_container
        component('tailwinds/form/multiselect/item_container', size:)
      end
    end
  end
end
