# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

class CreateActionTextTables < ActiveRecord::Migration[7.0]
  def change
    create_table :action_text_rich_texts, id: :string do |t|
      t.string     :name, null: false
      t.text       :body, size: :long
      t.string     :locale
      t.references :record, null: false, polymorphic: true, index: false, type: :string
      t.datetime   :deleted_at, index: { where: 'deleted_at IS NULL' }

      t.timestamps index: { where: 'deleted_at IS NULL' }

      t.index %i[record_type record_id name locale],
              name: :index_action_text_rich_texts_uniqueness,
              unique: true,
              where: 'deleted_at IS NULL'
    end
  end
end
