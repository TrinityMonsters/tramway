# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Container for dropdown component
      class DropdownContainerComponent < Tramway::BaseComponent
        option :size

        SIZE_CLASSES = {
          small: 'text-sm',
          medium: 'text-base',
          large: 'text-lg'
        }.freeze

        def dropdown_classes
          theme_classes(
            classic: 'absolute border-b border-l border-r border-gray-700 w-full z-40 lef-0 rounded-b-xl max-h-select overflow-y-auto ' \
                     'bg-gray-900 shadow-md ring-1 ring-gray-700 text-white' + " #{SIZE_CLASSES[size]}"
          )
        end
      end
    end
  end
end
