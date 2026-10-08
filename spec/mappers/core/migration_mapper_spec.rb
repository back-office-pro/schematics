# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::MigrationMapper do
  subject(:mapper) { described_class.new }

  describe '#call' do
    subject { mapper.call(params) }

    let(:params) do
      {
        'entities_attributes' => {
          '0' => {
            'id' => '7fd48606-93fd-4820-9f5a-88d813a16b85',
            'name' => 'product',
            'options_attributes' => {
              'descriptor' => 'price',
              'actions' => [
                'index'
              ],
              'icon' => 'box'
            },
            'attributes_attributes' => {
              '0' => {
                'id' => '16124c81-4abe-414d-ad28-55b36957db72',
                'type' => 'string',
                'name' => 'foo',
                'options_attributes' => {
                  'required' => 'true',
                  'readonly' => 'false',
                  'min' => '50'
                }
              },
              '1' => {
                'id' => '523d8d58-ffe9-43ab-8cb7-868ac4d0ae75',
                'type' => 'state_machine',
                'name' => 'state',
                'options_attributes' => {
                  'values' => %w[
                    pending
                    closed
                  ],
                  'events' => {
                    '0' => {
                      'id' => '76667a46-7392-4c38-a81c-836d4efcd72b',
                      'name' => 'close',
                      'from' => 'pending',
                      'to' => 'closed'
                    }
                  }
                }
              }
            },
            'virtuals_attributes' => {
              '0' => {
                'id' => '54d26529-8f7e-44ee-bc3c-e0d2933fa481',
                'name' => 'price',
                'function' => '$foo',
                'options_attributes' => {
                  'unit' => '$',
                  'precision' => '2'
                }
              }
            },
            'triggers_attributes' => {
              '0' => {
                'id' => '7380ee01-9c06-4591-a894-677bf4952dde',
                'action' => 'after_save',
                'callback' => '$foo = true'
              }
            },
            'has_and_belongs_to_many_associations_attributes' => {
              '0' => {
                'name' => 'products',
                'type' => 'has_and_belongs_to_many',
                'options_attributes' => {
                  'required' => 'true'
                }
              }
            }
          }
        }
      }
    end
    let(:expected_output) do
      {
        data: [
          id: '7fd48606-93fd-4820-9f5a-88d813a16b85',
          name: 'product',
          options: {
            descriptor: 'price',
            actions: [
              'index'
            ],
            icon: 'box'
          },
          attributes: [
            {
              id: '16124c81-4abe-414d-ad28-55b36957db72',
              name: 'foo',
              type: 'string',
              options: {
                required: true,
                min: 50
              }
            },
            {
              id: '523d8d58-ffe9-43ab-8cb7-868ac4d0ae75',
              name: 'state',
              type: 'state_machine',
              options: {
                values: %w[
                  pending
                  closed
                ],
                events: [
                  id: '76667a46-7392-4c38-a81c-836d4efcd72b',
                  name: 'close',
                  from: 'pending',
                  to: 'closed'
                ]
              }
            }
          ],
          virtuals: [
            id: '54d26529-8f7e-44ee-bc3c-e0d2933fa481',
            name: 'price',
            function: '$foo',
            options: {
              unit: '$',
              precision: 2
            }
          ],
          triggers: [
            id: '7380ee01-9c06-4591-a894-677bf4952dde',
            action: 'after_save',
            callback: '$foo = true'
          ],
          associations: [
            name: 'products',
            type: 'has_and_belongs_to_many',
            options: {
              required: true
            }
          ]
        ]
      }
    end

    it { is_expected.to eq(expected_output) }
  end
end
