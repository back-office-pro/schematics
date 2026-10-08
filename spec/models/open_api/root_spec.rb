# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Root do
  subject { described_class.new }

  let(:expected_hash) do
    {
      openapi: '3.1.1',
      security: [],
      tags: Array,
      paths: Hash,
      components: Hash
    }
  end

  its(:to_h) { is_expected.to match(expected_hash) }
end
