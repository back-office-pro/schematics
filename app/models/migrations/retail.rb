# frozen_string_literal: true

module Migrations
  module Retail
    module_function

    def data = [
      {
        id: SecureRandom.uuid,
        name: 'store',
        options: {
          icon: 'store',
          descriptor: 'name'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'name',
            type: 'string',
            options: {
              unique: true,
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'location',
            type: 'address',
            options: {
              required: true
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'merchandise',
        options: {
          icon: 'cart_shopping',
          descriptor: 'name'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'name',
            type: 'string',
            options: {
              unique: true,
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'quantity',
            type: 'integer'
          },
          {
            id: SecureRandom.uuid,
            name: 'price',
            type: 'currency',
            options: {
              precision: 2,
              unit: '$'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'store',
            type: 'belongs_to',
            options: {
              required: true
            }
          }
        ]
      }
    ]
  end
end
