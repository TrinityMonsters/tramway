# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Renders input as select
      class SelectAsInputComponent < Tramway::BaseComponent
        option :options
        option :attribute
        option :input
        option :size_class

        def base_classes
          theme_classes(
            classic: 'bg-transparent appearance-none outline-none h-full w-full hidden text-gray-100 ' \
                     'placeholder-gray-500'
          )
        end
      end
    end
  end
end
