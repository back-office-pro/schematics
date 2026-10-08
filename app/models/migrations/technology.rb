# frozen_string_literal: true

module Migrations
  module Technology
    module_function

    def data = [
      {
        id: SecureRandom.uuid,
        name: 'customer',
        options: {
          icon: 'user_tie',
          descriptor: 'full_name'
        },
        virtuals: [
          id: SecureRandom.uuid,
          name: 'full_name',
          function: '$first_name $last_name'
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'email',
            type: 'email',
            options: {
              unique: true,
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'first_name',
            type: 'string',
            options: {
              required: true,
              normalization: 'capitalize'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'last_name',
            type: 'string',
            options: {
              required: true,
              normalization: 'upcase'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'address',
            type: 'address',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'phone',
            type: 'phone',
            options: {
              required: true
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'project',
        options: {
          icon: 'folder',
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
            name: 'deadline',
            type: 'datetime',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'customer',
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
