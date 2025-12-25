# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class CreateFriendlyIdSlugs < ActiveRecord::Migration[8.1]
  def change
    create_table :friendly_id_slugs do |t|
      t.string     :slug, null: false
      t.references :sluggable, polymorphic: true, type: :string, index: false
      t.string     :scope
      t.string     :locale, null: false
      t.datetime   :deleted_at, index: { where: 'deleted_at IS NULL' }

      t.timestamps index: { where: 'deleted_at IS NULL' }
    end
    add_index :friendly_id_slugs, :locale, where: 'deleted_at IS NULL'
    add_index :friendly_id_slugs,
              %i[sluggable_type sluggable_id],
              where: 'deleted_at IS NULL'
    add_index :friendly_id_slugs,
              %i[slug sluggable_type locale],
              length: { slug: 140, sluggable_type: 50, locale: 2 },
              where: 'deleted_at IS NULL'
    add_index :friendly_id_slugs,
              %i[slug sluggable_type scope locale],
              length: { slug: 70, sluggable_type: 50, scope: 70, locale: 2 },
              name: :index_friendly_id_slugs_unique,
              unique: true,
              where: 'deleted_at IS NULL'
  end
end
