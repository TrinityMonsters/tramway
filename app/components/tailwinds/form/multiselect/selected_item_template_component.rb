# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Tailwind-styled multi-select field
      class SelectedItemTemplateComponent < Tramway::BaseComponent
        option :size

        SIZE_CLASSES = {
          small: 'text-sm',
          medium: 'text-base',
          large: 'text-lg'
        }.freeze

        def selected_item_classes
          theme_classes(
            classic: 'flex justify-center items-center font-medium py-1 px-2 rounded-xl border ' \
                     'text-white border-gray-700 shadow-md hover:bg-gray-800 cursor-pointer space-x-1' + " #{SIZE_CLASSES[size]}"
          )
        end
      end
    end
  end
end
