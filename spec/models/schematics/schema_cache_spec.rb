# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SchemaCache do
  subject { described_class }

  it { is_expected.not_to be_outdated }

  its(:entities) { is_expected.to be_all(Schematics::Entities::Entity) }
end
