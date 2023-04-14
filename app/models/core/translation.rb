# frozen_string_literal: true

module Core
  module Translation
    extend ActiveSupport::Concern

    prepended do
      scope :lookup, LookupQuery
    end
  end
end
