# frozen_string_literal: true

module Tailwinds
  module Table
    # Component for rendering a header in a table
    class HeaderComponent < Tramway::Component::Base
      option :headers, optional: true, default: -> { [] }
      option :columns, optional: true, default: -> { 3 }
      option :options, optional: true, default: -> { {} }

      def columns_count
        headers.present? ? headers.size : columns
      end

      def header_tag
        default_attributes = { aria: { label: "Table Header" }, role: :row }

        classes = [*default_classes, options[:class]].join(' ')

        tag.div(**options.merge(default_attributes), class: classes) do
          yield if block_given?
        end
      end

      private

      def default_classes
        [
          'div-table-row', 'grid', 'text-white',
          'text-small', 'gap-4', 'bg-purple-700',
          'dark:bg-gray-700', 'dark:text-gray-400',
          "grid-cols-#{columns_count}"
        ]
      end
    end
  end
end
