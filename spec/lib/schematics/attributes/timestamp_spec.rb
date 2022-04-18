# frozen_string_literal: true

describe Schematics::Attributes::Timestamp do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user') }
  let(:name) { 'reset_password_sent_at' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }

  its(:type) { is_expected.to eq('datetime') }
  its(:column_name) { is_expected.to eq('reset_password_sent_at') }
  its(:open_api_type) { is_expected.to eq(DateTime) }
  its(:validators) { is_expected.to be_empty }
  its(:validate) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.reset_password_sent_at') }
  its(:to_s) { is_expected.to eq('schema:user_reset_password_sent_at') }
end
