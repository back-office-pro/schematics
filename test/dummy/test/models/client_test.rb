# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  first_name :string           not null
#  last_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_clients_on_first_name  (first_name)
#  index_clients_on_last_name   (last_name)
#

require 'test_helper'

class ClientTest < Schematics::Tests::Model
end
