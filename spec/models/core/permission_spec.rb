# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permission do
  include Schematics::Specs::Model
  include Schematics::ResourcesHelper

  its(:model_class) { is_expected.to eq(User) }
  its(:webhook_event) { is_expected.to start_with('user.') }
  its(:webhook_url) { is_expected.to eq(resources_url(User, **record.default_url_options)) }

  describe '.create_entities_permissions!' do
    subject(:create_entities_permissions!) do
      described_class.create_entities_permissions!
    end

    it 'creates all entities permissions' do
      expect { create_entities_permissions! }
        .to change(described_class, :count)
        .by(123)
    end
  end
end
