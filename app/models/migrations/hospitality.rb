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
  module Hospitality # rubocop:disable Metrics/ModuleLength
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
        name: 'room',
        options: {
          icon: 'bed',
          descriptor: 'number'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'number',
            type: 'integer',
            options: {
              required: true
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'booking',
        options: {
          icon: 'book'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'customer',
            type: 'belongs_to',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'room',
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
