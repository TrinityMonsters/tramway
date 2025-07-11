# frozen_string_literal: true

class Tailwinds::ContainerComponent < BaseComponent
  option :id, optional: true, default: proc { SecureRandom.uuid }
end
