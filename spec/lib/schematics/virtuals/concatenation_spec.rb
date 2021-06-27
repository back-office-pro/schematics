# frozen_string_literal: true

require 'schematics/virtuals/concatenation'
require 'schematics/entities/entity'

describe Schematics::Virtuals::Concatenation do
  subject(:virtual) do
    described_class.create(entity, name: name, function: function, options: options)
  end

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'user',
      descriptor: 'full_name',
      attributes: [
        { name: 'first_name', type: 'string' },
        { name: 'last_name', type: 'string' }
      ]
    )
  end
  let(:name) { 'full_name' }
  let(:function) { '$first_name $profile.last_name' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:function) { is_expected.to eq("\"\#{first_name} \#{profile.last_name}\"") }
  its(:to_sql) { is_expected.to eq("CONCAT(users.first_name, ' ', profiles.last_name)") }
  its(:preload) { is_expected.to eq([:profile]) }
  its(:icon) { is_expected.to eq(:align_justify) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      full_name&.to_s&.parameterize(separator: ' ')
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      def full_name
        "\#{first_name} \#{profile.last_name}"
      rescue StandardError => e
        e
      end
    RUBY
  end
end
