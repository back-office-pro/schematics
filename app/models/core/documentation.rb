# frozen_string_literal: true

class Documentation < Schematics::ApplicationRecord
  attribute :data, default: -> { mapper.call generate_docs(!Rails.env.test?) }
  delegate :mapper, :generate_docs, to: :class, private: true

  class << self
    delegate :generate_docs, to: OpenApi

    def mapper = ::Core::DocumentationMapper.new
  end

  def data = super
    .deep_symbolize_keys
    .deep_merge mapper.call(generate_docs(!Rails.env.test?).merge(core: true))
end
