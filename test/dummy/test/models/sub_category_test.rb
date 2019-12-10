# == Schema Information
#
# Table name: sub_categories
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  designation :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#
# Indexes
#
#  index_sub_categories_on_category_id  (category_id)
#  index_sub_categories_on_designation  (designation) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#

require 'test_helper'

class SubCategoryTest < Schematics::Tests::Model
end
