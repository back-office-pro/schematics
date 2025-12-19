# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class CreateSearchIndexes < ActiveRecord::Migration[8.1]
  def change
    create_virtual_table :search_indexes,
                         :fts5,
                         [
                           'content',
                           'searchable_type',
                           'searchable_id',
                           "tokenize='unicode61 remove_diacritics 2'"
                         ]
  end
end
