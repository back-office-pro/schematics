# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  fixtures :users
  fixtures :roles

  subject(:user) { users(:one) }

  it { is_expected.to be_valid }
  it { is_expected.to have_implicit_order_column(:created_at) }

  describe '#id' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
  end

  describe '#email' do
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_index(:email).unique }
  end

  describe '#password' do
    it { is_expected.to have_secure_password(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
    it { is_expected.to have_db_column(:password_digest).of_type(:string) }
  end

  describe '#auth_token' do
    it { is_expected.to have_secure_token(:auth_token) }
    it { is_expected.to have_db_column(:auth_token).of_type(:string) }
    it { is_expected.to have_db_index(:auth_token).unique }
  end

  describe '#password_reset_token' do
    it { is_expected.to have_secure_token(:password_reset_token) }
    it { is_expected.to have_db_column(:password_reset_token).of_type(:string) }
    it { is_expected.to have_db_index(:password_reset_token).unique }
  end

  describe '#first_name' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to have_db_column(:first_name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_index(:first_name) }
  end

  describe '#last_name' do
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to have_db_column(:last_name).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_index(:last_name) }
  end

  describe '#avatar' do
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe '#locale' do
    it { is_expected.to validate_presence_of(:locale) }
    it { is_expected.to define_enum_for(:locale) }
    it { is_expected.to have_db_column(:locale).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_index(:locale) }
  end

  describe '#time_zone' do
    it { is_expected.to validate_presence_of(:time_zone) }
    it { is_expected.to have_db_index(:time_zone) }

    it do
      expect(user)
        .to have_db_column(:time_zone)
        .of_type(:string)
        .with_options(null: false)
    end
  end

  describe '#preferences' do
    it { is_expected.to have_db_index(:preferences) }

    it do
      expect(user)
        .to have_db_column(:preferences)
        .of_type(:jsonb)
        .with_options(default: {})
    end
  end

  describe '#role' do
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to have_db_column(:role_id).of_type(:uuid).with_options(null: false) }

    it do
      expect(user)
        .to belong_to(:role)
        .class_name('Role')
        .with_foreign_key('role_id')
        .inverse_of(:users)
        .counter_cache(:users_count)
    end
  end

  describe '#full_name' do
    it { is_expected.to respond_to(:full_name) }
  end
end
