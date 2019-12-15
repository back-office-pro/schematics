module Schematics
  module Renderable
    def icon
      :align_justify
    end

    def visible?
      true
    end

    def searchable?
      false
    end

    def format(value)
      value
    end
  end
end
