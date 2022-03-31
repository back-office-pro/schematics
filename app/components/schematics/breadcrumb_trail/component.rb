# frozen_string_literal: true

module Schematics
  module BreadcrumbTrail
    class Component < ApplicationComponent
      delegate :root_path, to: 'Schematics::Engine.routes.url_helpers'
    end
  end
end
