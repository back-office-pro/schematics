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

module Schematics
  class ProfileController < ApplicationController
    include Fillable

    helper_method :attributes

    def edit; end

    def update
      result = Resources::Update.call(resource: current_user, resource_params:)
      switch_localization do
        respond_with result, location: edit_profile_path
      end
    end

    private

    def attributes = entity
      .fillable_elements
      .insert(2, password_challenge_attribute)

    def password_challenge_attribute = Attributes::Digest.new(
      entity:,
      name: 'password_challenge',
      options: { required: true }
    )

    def model_class = ::User

    def permitted_params = super.push(:password_challenge)
  end
end
