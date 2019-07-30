module Simpler
  class View
    class Render

      attr_reader :template

      def initialize(template)
        @template = template
      end

      def render(binding); end

    end
  end
end
