# frozen_string_literal: true

module Main
  class AdminUser < MainRecord
    self.table_name = 'clients' # rubocop:disable Rails/TableNameAssignment
  end
end
