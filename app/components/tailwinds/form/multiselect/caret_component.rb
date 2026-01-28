class Tailwinds::Form::Multiselect::CaretComponent < Tramway::BaseComponent
  option :direction
  option :size

  SIZE_CLASSES = {
    small: 'w-3 h-3',
    medium: 'w-4 h-4',
    large: 'w-6 h-6'
  }.freeze
end
