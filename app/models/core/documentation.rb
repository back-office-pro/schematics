# frozen_string_literal: true

class Documentation < Schematics::ApplicationRecord
  attribute :data, default: -> { mapper.call(open_api_data) }
  delegate :mapper, :open_api_data, to: :class, private: true

  class << self
    def mapper = ::Core::DocumentationMapper.new

    def open_api_data = OpenApi.generate_docs(!Rails.env.test?)
  end

  def data = super
    .deep_symbolize_keys
    .deep_merge mapper.call(open_api_data.merge(core: true))
end
