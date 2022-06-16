# frozen_string_literal: true

module Schematics
  module Attachable
    extend ActiveSupport::Concern

    included do
      include ActionText::Attachable
    end

    def to_partial_path
      'schematics/mention'
    end
  end
end
