# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Permissions::FeaturesQuery do
  let(:permissions) { Core::Permission.create_all_entities_permissions! }
  let(:expected_permissions) do
    [
      Core::Permission.where(model: 'Import').to_a,
      Core::Permission.where(model: 'Message').to_a,
      Core::Permission.where(model: 'Comment').to_a,
      Core::Permission.where(model: 'Meeting').to_a,
      Core::Permission.where(model: 'Task').to_a,
      Core::Permission.where(model: 'Chart', action: 'show'),
      Core::Permission.where(model: 'ActiveStorage::Blob', action: 'index')
    ].flatten
  end

  before { permissions }

  its(:call) { is_expected.to match_array(expected_permissions) }
end
