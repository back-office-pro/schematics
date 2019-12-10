# == Schema Information
#
# Table name: directories
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
# Indexes
#
#  index_directories_on_name       (name) UNIQUE
#  index_directories_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => directories.id)
#

require 'test_helper'

class DirectoryTest < Schematics::Tests::Model
end
