module Schematics
  module SearchBar
    class Component < ApplicationComponent
      delegate :searches_path, to: 'Schematics::Engine.routes.url_helpers'
    end
  end
end
