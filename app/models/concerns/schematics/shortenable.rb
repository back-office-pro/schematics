# frozen_string_literal: true

module Schematics
  module Shortenable
    extend ActiveSupport::Concern

    def to_param = UUID::Shortener.shorten(id)
  end
end
