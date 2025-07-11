# frozen_string_literal: true

module Tramway
  module Configs
    module Entities
      # Route struct describes rules for route management
      #
      class Page < Dry::Struct
        attribute :action, Types::Coercible::String
        attribute? :scope, Types::Coercible::String

        def default_route_method(entity_name)
          default = case action.to_sym
                    when :index
                      entity_name.parameterize.pluralize.underscore
                    when :create
                      "new_#{entity_name.parameterize.underscore}"
                    else
                      raise "Action is not supported: #{action}. Possible values are :index, :create, :update, :show, :destroy"
                    end

          "#{default}_path"
        end
      end
    end
  end
end
