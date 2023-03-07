# frozen_string_literal: true

module Application
  module Translation
    extend ActiveSupport::Concern

    prepended do
      scope :lookup, LookupQuery
    end
  end
end
