# frozen_string_literal: true

module Core
  module ChartSerializer
    delegate :serializable_hash, to: :object
  end
end
