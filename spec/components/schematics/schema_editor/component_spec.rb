# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SchemaEditor::Component, type: :component do
  subject(:component) { render_inline described_class.new(resource:) }

  let(:resource) { Migration.new(data:) }
  let(:data) do
    [
      id: '7a90edf6-4a7f-4f08-8686-5b0d44ff445b',
      name: 'client',
      options: {
        descriptor: 'full_name',
        icon: 'user_tie'
      },
      attributes: [
        {
          id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
          name: 'first_name',
          type: 'string',
          options: {
            required: true
          }
        },
        {
          id: '2bc432df-7a51-49e7-8fa2-c13ea437d6ff',
          name: 'state',
          type: 'state_machine',
          options: {
            default: 'pending',
            values: %w[
              pending
              closed
              refused
            ],
            events: [
              {
                id: '11356c14-46af-4f69-b910-6b04c12acf7a',
                name: 'close',
                from: 'pending',
                to: 'closed',
                icon: 'check',
                color: 'success',
                callback: '$in_stock = false'
              },
              {
                id: '701c443e-0c8b-4aa1-b9bd-aa264ea11045',
                name: 'refuse',
                from: 'pending',
                to: 'refused',
                icon: 'user',
                color: 'danger',
                confirm: true
              },
              {
                id: '407ac568-dc72-45c5-83d4-f6207e5db604',
                name: 'reopen',
                from: %w[
                  closed
                  refused
                ],
                to: 'pending',
                icon: 'users',
                color: 'warning'
              }
            ]
          }
        }
      ],
      virtuals: [
        id: '9c464a01-9b47-405a-ba24-c02880921604',
        name: 'full_name',
        function: '$first_name $last_name'
      ],
      triggers: [
        id: '83cca8ab-7268-45b2-a0c9-9b6be158e331',
        action: 'after_save',
        callback: '$error.foo = true'
      ],
      associations: [
        name: 'users',
        type: 'has_and_belongs_to_many',
        options: {
          required: true
        }
      ]
    ]
  end

  describe 'Entity fields' do
    it 'has an id hidden field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][id]',
        with: '7a90edf6-4a7f-4f08-8686-5b0d44ff445b',
        type: 'hidden'
      )
    end

    it 'has a name field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][name]',
        with: 'client'
      )
    end

    it 'has an actions dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][options_attributes][actions][]',
        selected: %w[Add Archive View Edit List Delete]
      )
    end

    it 'has a descriptor dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][options_attributes][descriptor]',
        selected: 'full_name'
      )
    end
  end

  describe 'Attribute fields' do
    it 'has a first id hidden field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][0][id]',
        with: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
        type: 'hidden'
      )
    end

    it 'has a first name field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][0][name]',
        with: 'first_name'
      )
    end

    it 'has a first type dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][0][type]',
        selected: 'String'
      )
    end

    it 'has a checked required option' do
      expect(component).to have_checked_field(
        'migration[entities_attributes][0][attributes_attributes][0][options_attributes][required]'
      )
    end

    it 'has a second id hidden field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][id]',
        with: '2bc432df-7a51-49e7-8fa2-c13ea437d6ff',
        type: 'hidden'
      )
    end

    it 'has a second name field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][name]',
        with: 'state'
      )
    end

    it 'has a second type dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][type]',
        selected: 'State machine'
      )
    end

    it 'has a default value option field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][default]',
        with: 'pending'
      )
    end

    it 'has a values option dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][values][]',
        selected: %w[pending closed refused]
      )
    end
  end

  describe 'Event fields' do
    it 'has a first id hidden field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][0][id]', # rubocop:disable Layout/LineLength
        with: '11356c14-46af-4f69-b910-6b04c12acf7a',
        type: 'hidden'
      )
    end

    it 'has a first name field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][0][name]', # rubocop:disable Layout/LineLength
        with: 'close'
      )
    end

    it 'has a first icon dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][0][icon]', # rubocop:disable Layout/LineLength
        selected: 'check'
      )
    end

    it 'has a first from dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][0][from][]', # rubocop:disable Layout/LineLength
        selected: 'pending'
      )
    end

    it 'has a first to dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][0][to]', # rubocop:disable Layout/LineLength
        selected: 'closed'
      )
    end

    it 'has a first color dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][0][color]', # rubocop:disable Layout/LineLength
        selected: 'success'
      )
    end

    it 'has a callback field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][0][callback]', # rubocop:disable Layout/LineLength
        with: '$in_stock = false'
      )
    end

    it 'has a second id hidden field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][1][id]', # rubocop:disable Layout/LineLength
        with: '701c443e-0c8b-4aa1-b9bd-aa264ea11045',
        type: 'hidden'
      )
    end

    it 'has a checked confirm option' do
      expect(component).to have_checked_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][1][confirm]' # rubocop:disable Layout/LineLength
      )
    end

    it 'has a second name field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][1][name]', # rubocop:disable Layout/LineLength
        with: 'refuse'
      )
    end

    it 'has a second icon dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][1][icon]', # rubocop:disable Layout/LineLength
        selected: 'user'
      )
    end

    it 'has a second from dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][1][from][]', # rubocop:disable Layout/LineLength
        selected: 'pending'
      )
    end

    it 'has a second to dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][1][to]', # rubocop:disable Layout/LineLength
        selected: 'refused'
      )
    end

    it 'has a second color dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][1][color]', # rubocop:disable Layout/LineLength
        selected: 'danger'
      )
    end

    it 'has a third id hidden field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][2][id]', # rubocop:disable Layout/LineLength
        with: '407ac568-dc72-45c5-83d4-f6207e5db604',
        type: 'hidden'
      )
    end

    it 'has a third name field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][2][name]', # rubocop:disable Layout/LineLength
        with: 'reopen'
      )
    end

    it 'has a third icon dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][2][icon]', # rubocop:disable Layout/LineLength
        selected: 'users'
      )
    end

    it 'has a third from dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][2][from][]', # rubocop:disable Layout/LineLength
        selected: %w[closed refused]
      )
    end

    it 'has a third to dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][2][to]', # rubocop:disable Layout/LineLength
        selected: 'pending'
      )
    end

    it 'has a third color dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][attributes_attributes][1][options_attributes][events][2][color]', # rubocop:disable Layout/LineLength
        selected: 'warning'
      )
    end
  end

  describe 'Virtual fields' do
    it 'has an id hidden field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][virtuals_attributes][0][id]',
        with: '9c464a01-9b47-405a-ba24-c02880921604',
        type: 'hidden'
      )
    end

    it 'has a name field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][virtuals_attributes][0][name]',
        with: 'full_name'
      )
    end

    it 'has a function field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][virtuals_attributes][0][function]',
        with: '$first_name $last_name'
      )
    end
  end

  describe 'Trigger fields' do
    it 'has an id hidden field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][triggers_attributes][0][id]',
        with: '83cca8ab-7268-45b2-a0c9-9b6be158e331',
        type: 'hidden'
      )
    end

    it 'has an action dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][triggers_attributes][0][action]',
        selected: 'After save'
      )
    end

    it 'has a callback field' do
      expect(component).to have_field(
        'migration[entities_attributes][0][triggers_attributes][0][callback]',
        with: '$error.foo = true'
      )
    end
  end

  describe 'Association fields' do
    it 'has a name dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][has_and_belongs_to_many_associations_attributes][0][name]', # rubocop:disable Layout/LineLength
        selected: 'users'
      )
    end

    it 'has a type dropdown' do
      expect(component).to have_select(
        'migration[entities_attributes][0][has_and_belongs_to_many_associations_attributes][0][type]', # rubocop:disable Layout/LineLength
        selected: 'Many-to-many association'
      )
    end

    it 'has a checked required option' do
      expect(component).to have_checked_field(
        'migration[entities_attributes][0][has_and_belongs_to_many_associations_attributes][0][options_attributes][required]' # rubocop:disable Layout/LineLength
      )
    end
  end
end
