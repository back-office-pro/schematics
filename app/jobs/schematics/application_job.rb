# frozen_string_literal: true

module Schematics
  class ApplicationJob < ::ApplicationJob
    queue_as :app
  end
end
