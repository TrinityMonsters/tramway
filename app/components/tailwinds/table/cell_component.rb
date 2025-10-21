# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a cell in a table
    class CellComponent < Tramway::Component::Base
      option :options, optional: true, default: -> { {} }

      def cell_tag
        classes = [*default_classes, options[:class]].join(' ')

        tag.div(**options, class: classes) do
          yield if block_given?
        end
      end

      private

      def default_classes
        [
          'div-table-cell', 'px-6', 'py-4', 'font-medium', 'text-gray-900', 'whitespace-nowrap', 'dark:text-white', 'text-xs.sm:text-base'
        ]
      end
    end
  end
end
