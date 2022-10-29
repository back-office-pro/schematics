# frozen_string_literal: true

module Application
  module DocumentationSerializer
    delegate :serializable_hash, to: :object
  end
end
