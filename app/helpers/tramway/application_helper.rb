# frozen_string_literal: true

require 'tramway/helpers/component_helper'
require 'kaminari/helpers/tag'

module Tramway
  # Main helper module for Tramway entities pages
  module ApplicationHelper
    include Tramway::Decorators::ClassHelper
    include Tramway::Helpers::ComponentHelper

    def index_page_title
      @model_class.model_name.human.pluralize # rubocop:disable Rails/HelperInstanceVariable
    end

    def create_page_title(model:)
      t('actions.create', model: model.model_name)
    end

    def update_page_title(model:)
      t('actions.update', model: model.model_name)
    end
  end
end
