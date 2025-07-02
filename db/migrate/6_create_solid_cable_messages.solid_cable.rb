# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class CreateSolidCableMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_cable_messages do |t|
      t.binary :channel, null: false
      t.binary :payload, null: false
      t.datetime :created_at, null: false
      t.bigint :channel_hash, null: false
      t.index %i[channel], name: :index_solid_cable_messages_on_channel
      t.index %i[channel_hash], name: :index_solid_cable_messages_on_channel_hash
      t.index %i[created_at], name: :index_solid_cable_messages_on_created_at
    end
  end
end
