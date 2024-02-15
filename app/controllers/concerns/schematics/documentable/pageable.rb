# frozen_string_literal: true

module Schematics
  module Documentable
    module Pageable
      extend ActiveSupport::Concern

      included do
        api_dry :index do
          header 'link', ::String, desc: 'Current link of item'
          header 'current-page', ::Integer, desc: 'Current page number'
          header 'page-items', ::Integer, desc: 'Number of items per page'
          header 'total-pages', ::Integer, desc: 'Total number of pages'
          header 'total-count', ::Integer, desc: 'Total number of items'
        end
      end
    end
  end
end
