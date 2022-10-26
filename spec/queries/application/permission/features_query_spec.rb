# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::Permission::FeaturesQuery do
  let(:permissions) { ::Permission.create_all_entities_permissions! }
  let(:expected_permissions) do
    [
      Permission.where(model: 'Import').to_a,
      Permission.where(model: 'Message').to_a,
      Permission.where(model: 'Comment').to_a,
      Permission.where(model: 'Meeting').to_a,
      Permission.where(model: 'Task').to_a,
      Permission.where(model: 'Stat', action: 'show')
    ].flatten
  end

  before { permissions }

  its(:call) { is_expected.to contain_exactly(*expected_permissions) }
end
