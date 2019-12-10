# == Schema Information
#
# Table name: products
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  description     :string
#  designation     :string(100)
#  in_stock        :boolean          default(FALSE)
#  price           :decimal(5, 2)
#  state           :integer          default("available")
#  vat             :float            default(19.6)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sub_category_id :bigint           not null
#
# Indexes
#
#  index_products_on_description      (description)
#  index_products_on_designation      (designation) UNIQUE
#  index_products_on_in_stock         (in_stock)
#  index_products_on_price            (price)
#  index_products_on_state            (state)
#  index_products_on_sub_category_id  (sub_category_id)
#  index_products_on_vat              (vat)
#
# Foreign Keys
#
#  fk_rails_...  (sub_category_id => sub_categories.id)
#

require 'test_helper'

class ProductTest < Schematics::Tests::Model
end
