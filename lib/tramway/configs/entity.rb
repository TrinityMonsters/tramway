# frozen_string_literal: true

require 'tramway/configs/entities/route'
require 'tramway/configs/entities/page'

module Tramway
  module Configs
    # Tramway is an entity-based framework
    class Entity < Dry::Struct
      attribute :name, Types::Coercible::String
      attribute? :pages, Types::Array.of(Tramway::Configs::Entities::Page).default([].freeze)
      attribute? :route, Tramway::Configs::Entities::Route

      DEFAULT_ROUTES = [ :index, :create, :update, :show, :destroy ]

      # Route Struct contains implemented in Tramway CRUD and helpful routes for the entity
      RouteStruct = Struct.new(*DEFAULT_ROUTES)

      # HumanName Struct contains human names forms for the entity
      HumanNameStruct = Struct.new(:single, :plural)

      def routes
        RouteStruct.new(*route_helper_method)
      end

      def human_name
        single, plural = if model_class.present?
                           model_name = model_class.model_name.human
                           [model_name, pluralized(model_name)]
                         else
                           [name.capitalize, name.pluralize.capitalize]
                         end

        HumanNameStruct.new(single, plural)
      end

      def page(name)
        pages.find { |page| page.action == name.to_s }
      end

      private

      def pluralized(model_name)
        local_plural = I18n.t("#{name}.many", scope: 'activerecord.plural.models', default: nil)

        local_plural.presence || model_name.pluralize
      end

      def model_class
        name.classify.constantize
      rescue StandardError
        nil
      end

      def route_helper_method
        DEFAULT_ROUTES.map do |action_name|
          if page_set?(action_name)
            method_name = if page_set?(action_name) || route.blank?
                            page(action_name).default_route_method(name)
                          else
                            route.helper_method_by(underscored_name)
                          end

            route_helper_engine.routes.url_helpers.public_send(method_name)
          end
        end
      end

      def route_helper_engine
        page_set?(:index) ? Tramway::Engine : Rails.application
      end

      alias page_set? page
    end
  end
end
