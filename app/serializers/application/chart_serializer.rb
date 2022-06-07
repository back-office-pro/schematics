# frozen_string_literal: true

module Application
  module ChartSerializer
    delegate :serializable_hash, to: :object
  end
end
