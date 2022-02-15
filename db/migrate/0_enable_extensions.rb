# frozen_string_literal: true

class EnableExtensions < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'
    enable_extension 'citext'
  end
end
