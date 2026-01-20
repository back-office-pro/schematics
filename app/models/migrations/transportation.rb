# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Migrations
  module Transporation # rubocop:disable Metrics/ModuleLength
    module_function

    def data = [
      {
        id: SecureRandom.uuid,
        name: 'driver',
        options: {
          icon: 'id_card',
          descriptor: 'full_name'
        },
        virtuals: [
          {
            id: SecureRandom.uuid,
            name: 'full_name',
            function: '$first_name $last_name'
          }
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
            name: 'phone_number',
            type: 'phone',
            options: {
              required: true
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'parcel',
        options: {
          icon: 'box'
        },
        attributes: [
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
        name: 'tour',
        options: {
          icon: 'truck'
        },
        associations: [
          {
            name: 'parcels',
            type: 'has_and_belongs_to_many',
            options: {
              required: true
            }
          }
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'driver',
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
          },
          {
            id: SecureRandom.uuid,
            name: 'state',
            type: 'state_machine',
            options: {
              required: true,
              default: 'pending',
              values: %w[pending in_progress finished],
              events: [
                {
                  id: SecureRandom.uuid,
                  name: 'start',
                  icon: 'play',
                  from: 'pending',
                  to: 'in_progress'
                },
                {
                  id: SecureRandom.uuid,
                  name: 'finish',
                  icon: 'stop',
                  from: 'in_progress',
                  to: 'finished'
                }
              ]
            }
          }
        ]
      }
    ]
  end
end
