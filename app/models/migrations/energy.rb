# frozen_string_literal: true

module Migrations
  module Energy
    module_function

    def data = [
      {
        id: SecureRandom.uuid,
        name: 'technician',
        options: {
          icon: 'user',
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
        name: 'intervention',
        options: {
          icon: 'calendar'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'technician',
            type: 'belongs_to',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'start_at',
            type: 'datetime',
            options: {
              required: true,
              start_date: true,
              less_than: 'end_at'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'end_at',
            type: 'datetime',
            options: {
              required: true,
              end_date: true,
              greater_than: 'start_at'
            }
          }
        ]
      }
    ]
  end
end
