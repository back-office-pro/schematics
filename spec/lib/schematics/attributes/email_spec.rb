# frozen_string_literal: true

describe Schematics::Attributes::Email do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user') }
  let(:name) { 'email' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('citext') }
  its(:column_name) { is_expected.to eq('email') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:envelope) }
  its(:default) { is_expected.to match(URI::MailTo::EMAIL_REGEXP) }
  its(:validators) { is_expected.to eq(email: { allow_blank: true }) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.email') }
  its(:to_s) { is_expected.to eq('schema:user_email') }
  it { is_expected.to be_encrypted }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      encrypts :email, deterministic: true
    RUBY
  end

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :email, {:email=>{:allow_blank=>true}}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      email: email&.to_s
    RUBY
  end

  context 'when email is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:validators) do
      is_expected.to eq(
        uniqueness: { case_sensitive: false, allow_blank: true },
        email: { allow_blank: true }
      )
    end

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :email, {:uniqueness=>{:case_sensitive=>false, :allow_blank=>true}, :email=>{:allow_blank=>true}}
      RUBY
    end
  end

  context 'when email is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true, email: { allow_blank: false }) }

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :email, {:presence=>true, :email=>{:allow_blank=>false}}
      RUBY
    end
  end
end
