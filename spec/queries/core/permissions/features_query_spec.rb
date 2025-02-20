# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Permissions::FeaturesQuery do
  let(:permissions) { Permission.create_entities_permissions! }
  let(:expected_permissions) do
    [
      Permission.where(model: 'Import').to_a,
      Permission.where(model: 'Message').to_a,
      Permission.where(model: 'Comment').to_a,
      Permission.where(model: 'Meeting').to_a,
      Permission.where(model: 'Task').to_a,
      Permission.where(model: 'Chart', action: 'show'),
      Permission.where(model: 'Metric', action: 'show'),
      Permission.where(model: 'Ranking', action: 'show'),
      Permission.where(model: 'ActiveStorage::Blob', action: 'index')
    ].flatten
  end

  before { permissions }

  its(:call) { is_expected.to match_array(expected_permissions) }
end
