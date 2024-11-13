# frozen_string_literal: true

class CreateFunctionImmutableUnaccent < ActiveRecord::Migration[7.2]
  def change
    create_function :immutable_unaccent
  end
end
