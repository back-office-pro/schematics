# frozen_string_literal: true

module MainApp
  module Search
    extend ActiveSupport::Concern

    prepended do
      belongs_to :user
    end
  end
end
