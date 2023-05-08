# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Permissions::FeaturesQuery do
  let(:permissions) { Core::Permission.create_entities_permissions! }
  let(:expected_permissions) do
    [
      Core::Permission.where(model: 'Core::Import').to_a,
      Core::Permission.where(model: 'Core::Message').to_a,
      Core::Permission.where(model: 'Core::Comment').to_a,
      Core::Permission.where(model: 'Core::Meeting').to_a,
      Core::Permission.where(model: 'Core::Task').to_a,
      Core::Permission.where(model: 'Core::Chart', action: 'show'),
      Core::Permission.where(model: 'ActiveStorage::Blob', action: 'index')
    ].flatten
  end

  before { permissions }

  its(:call) { is_expected.to match_array(expected_permissions) }
end
