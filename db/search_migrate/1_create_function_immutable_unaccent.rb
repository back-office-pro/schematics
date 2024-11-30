# frozen_string_literal: true

class CreateFunctionImmutableUnaccent < ActiveRecord::Migration[8.0]
  def change
    create_function :immutable_unaccent
  end
end
