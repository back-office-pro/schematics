# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SchemaEditor::Component, type: :component do
  subject { render_inline described_class.new(schema:) }

  let(:schema) { Schematics::Schema.load(data) }
  let(:data) do
    [
      {
        name: 'client',
        options: {
          descriptor: 'full_name',
          icon: 'user_tie'
        },
        attributes: [
          {
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'first_name',
            type: 'string'
          },
          {
            id: '2bc432df-7a51-49e7-8fa2-c13ea437d6ff',
            name: 'state',
            type: 'state_machine'
          }
        ],
        virtuals: [
          {
            name: 'full_name',
            function: '$first_name $last_name'
          }
        ],
        triggers: [
          {
            action: 'save',
            callback: '$error.foo = true'
          }
        ],
        associations: [
          {
            name: 'user',
            type: 'has_and_belongs_to_many'
          }
        ]
      }
    ]
  end

  describe 'Entity fields' do
    it { is_expected.to have_field('Name', with: 'client') }
    it { is_expected.to have_select('Actions', selected: %w[Add Archive View Edit List Delete]) }
    it { is_expected.to have_select('Descriptor', selected: 'full_name') }
  end

  describe 'Attribute fields' do
    it { is_expected.to have_field('Name', with: 'first_name') }
    it { is_expected.to have_select('Type', selected: 'String') }
    it { is_expected.to have_field('Name', with: 'state') }
    it { is_expected.to have_select('Type', selected: 'State machine') }
  end

  describe 'Virtual fields' do
    it { is_expected.to have_field('Name', with: 'full_name') }
    it { is_expected.to have_field('Function', with: '$first_name $last_name') }
  end

  describe 'Trigger fields' do
    it { is_expected.to have_select('Action', selected: 'Save') }
    it { is_expected.to have_field('Callback', with: '$error.foo = true') }
  end

  describe 'Association fields' do
    it { is_expected.to have_select('Type', selected: 'Many-to-many association') }
  end
end
