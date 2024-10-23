# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permission do
  include Schematics::Specs::Model
  include Rails.application.routes.url_helpers

  its(:model_class) { is_expected.to eq(User) }
  its(:webhook_event) { is_expected.to start_with('user.') }
  its(:webhook_url) { is_expected.to eq(polymorphic_url(User)) }

  describe '.create_entities_permissions!' do
    subject(:create_entities_permissions!) do
      described_class.create_entities_permissions!
    end

    it 'creates all entities permissions' do
      expect { create_entities_permissions! }
        .to change(described_class, :count)
        .by(125)
    end
  end

  describe '.create_entity_permissions!' do
    subject(:create_entity_permissions!) do
      described_class.create_entity_permissions!(entity)
    end

    let(:entity) { described_class.entity }

    it 'creates entity permissions' do
      expect { create_entity_permissions! }
        .to change(described_class, :count)
        .by(2)
    end
  end
end
