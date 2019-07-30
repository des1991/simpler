require 'erb'

module Simpler
  class View
    class Erb < Render

      def render(binding)
        ERB.new(template).result(binding)
      end

    end
  end
end
