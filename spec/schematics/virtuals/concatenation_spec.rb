require 'schematics/virtuals/concatenation'
require 'schematics/entities/entity'
require 'schematics/tokens/tokenizer'

describe Schematics::Virtuals::Concatenation do
  subject(:virtual) { described_class.new(entity, name, tokens, options) }

  let(:entity) do
    Schematics::Entities::Entity.create(
      name: 'user',
      descriptor: 'full_name',
      attributes: [
        { name: 'first_name', type: 'string' },
        { name: 'last_name', type: 'string' },
      ]
    )
  end
  let(:name) { 'full_name' }
  let(:options) { {} }
  let(:tokens) do
    Schematics::Tokens::Tokenizer.tokenize('$first_name $profile.last_name', 'users')
  end

  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }

  its(:function) { is_expected.to eq("\"\#{first_name} \#{profile.last_name}\"") }
  its(:to_sql) { is_expected.to eq("CONCAT(users.first_name, ' ', profiles.last_name)") }
  its(:preload) { is_expected.to eq([:profile]) }
  its(:icon) { is_expected.to eq(:align_justify) }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      full_name&.parameterize(separator: ' ')
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      default_scope { includes([:profile]) }

      def full_name
        "\#{first_name} \#{profile.last_name}"
      rescue NameError => e
        Virtuals::Errors::NameError.new(e.message, e.name)
      rescue TypeError => e
        Virtuals::Errors::TypeError.new(e.message)
      end
    RUBY
  end
end
