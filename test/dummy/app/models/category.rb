# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  deleted_at  :datetime
#  designation :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_categories_on_designation  (designation) UNIQUE
#

class Category < Schematics::ApplicationRecord
end
