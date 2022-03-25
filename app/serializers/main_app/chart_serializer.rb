# frozen_string_literal: true

module MainApp
  module ChartSerializer
    delegate :serializable_hash, to: :object
  end
end
