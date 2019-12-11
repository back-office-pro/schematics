# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  designation :string           not null
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_categories_on_designation  (designation) UNIQUE
#  index_categories_on_slug         (slug) UNIQUE
#

require 'test_helper'

class CategoryTest < Schematics::Tests::Model
end
