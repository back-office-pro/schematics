# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Migration do
  include Schematics::Specs::Model

  its(:migrator) { is_expected.to be_a(Schematics::Migrator) }

  its(:to_yaml) do
    is_expected.to eq <<~YAML
      ---
      one:
        state: finished
        data_version: 1.5
        data: []
    YAML
  end
end
