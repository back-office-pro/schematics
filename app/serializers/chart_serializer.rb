# frozen_string_literal: true

class ChartSerializer < ActiveModel::Serializer
  include Schematics::JsonSerializer
  delegate :serializable_hash, to: :object
end
