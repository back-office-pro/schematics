# frozen_string_literal: true

class EnableExtensions < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto'
    enable_extension 'unaccent'
  end
end
