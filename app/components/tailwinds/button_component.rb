class Tailwinds::ButtonComponent < Tramway::Component::Base
  option :text
  option :path
  option :color, default: -> { :blue }
  option :type, default: -> { :default }
  option :size, default: -> { :middle }
  option :method, optional: true, default: -> { :get }
  option :options, optional: true, default: -> { {} }

  def size_classes
    case size
    when :small
      'text-sm py-1 px-1'
    when :middle
      'py-2 px-4'
    end
  end
end
