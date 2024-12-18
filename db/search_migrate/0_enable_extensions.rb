# frozen_string_literal: true

class EnableExtensions < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'unaccent'
  end
end
