# frozen_string_literal: true

describe Schematics::Virtuals::Concatenation do
  subject(:virtual) { described_class.build(entity, name:, function:, options:) }

  let(:entity) do
    Schematics::Entities::Entity.build(
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

  its(:open_api_type) { is_expected.to eq('string') }
  its(:to_sql) { is_expected.to eq("CONCAT(users.first_name, ' ', profiles.last_name)") }
  its(:preload) { is_expected.to eq([:profile]) }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:weight) { is_expected.to eq(1) }

  its(:function) do
    is_expected.to eq("\"\#{first_name_formatted} \#{profile.last_name_formatted}\"")
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      full_name: full_name&.to_s
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      define_attribute_method :full_name
      def full_name
        "\#{first_name_formatted} \#{profile.last_name_formatted}"
      rescue StandardError => e
        e.exception(Virtuals::Errors.const_get(e.class.to_s).new(e))
      end
    RUBY
  end
end
