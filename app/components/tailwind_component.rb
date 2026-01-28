# frozen_string_literal: true

require 'view_component'

# Base TailwindComponent. Contains base features for all tailwind components
class TailwindComponent < Tramway::BaseComponent
  option :input
  option :attribute
  option :value, optional: true
  option :options
  option :label
  option :for
  option :size, default: -> { :medium }

  SIZE_CLASSES = {
    small: {
      text_input: 'text-sm px-2 py-1',
      select_input: 'text-sm px-2 py-1',
      file_button: 'text-sm px-3 py-1',
      submit_button: 'text-sm px-3 py-1',
      multiselect_input: 'text-sm px-2 py-1 h-10'
    },
    medium: {
      text_input: 'text-base px-3 py-2',
      select_input: 'text-base px-3 py-2',
      file_button: 'text-base px-4 py-2',
      submit_button: 'text-base px-4 py-2',
      multiselect_input: 'text-base px-2 py-1 h-12'
    },
    large: {
      text_input: 'text-xl px-4 py-3',
      select_input: 'text-xl px-4 py-3',
      file_button: 'text-xl px-5 py-3',
      submit_button: 'text-xl px-5 py-3',
      multiselect_input: 'text-xl px-3 py-2 h-15'
    }
  }.freeze

  private

  def text_input_base_classes
    theme_classes(
      classic: 'w-full rounded-xl border border-gray-700 bg-gray-900 text-gray-100 shadow-inner ' \
               'focus:outline-none focus:ring-2 focus:ring-gray-600 placeholder-gray-500'
    )
  end

  def select_base_classes
    theme_classes(
      classic: 'w-full rounded-xl border border-gray-700 bg-gray-900 text-gray-100 shadow-inner ' \
               'focus:outline-none focus:ring-2 focus:ring-gray-600 disabled:cursor-not-allowed ' \
               'disabled:bg-gray-800 disabled:text-gray-500'
    )
  end

  def file_button_base_classes
    theme_classes(
      classic: 'inline-block text-blue-100 font-semibold rounded-xl cursor-pointer mt-4 bg-blue-900 ' \
               'hover:bg-blue-800 shadow-md'
    )
  end

  def submit_button_base_classes
    theme_classes(
      classic: 'font-semibold rounded-xl focus:outline-none focus:ring-2 focus:ring-red-700 cursor-pointer ' \
               'bg-green-900 hover:bg-green-800 shadow-md'
    )
  end

  def form_label_classes
    theme_classes(
      classic: 'block text-sm font-semibold mb-2 text-gray-200'
    )
  end

  def size_class(key)
    size_classes = SIZE_CLASSES.fetch(size) { SIZE_CLASSES[:medium] }
    size_classes.fetch(key) { SIZE_CLASSES[:medium].fetch(key) }
  end
end
