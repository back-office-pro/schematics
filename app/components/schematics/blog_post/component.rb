# frozen_string_literal: true

module Schematics
  module BlogPost
    class Component < ApplicationComponent
      delegate :title, :image, :content, :author, :created_at, to: :post
      option :post
    end
  end
end
