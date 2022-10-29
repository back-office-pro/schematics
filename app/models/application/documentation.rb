# frozen_string_literal: true

module Application
  module Documentation
    extend ActiveSupport::Concern

    def load!
      update!(data: ::OpenApi.generate_docs(true).fetch(:open_api))
    end

    def serializable_hash(*) = data
  end
end
