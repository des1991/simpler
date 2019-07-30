require_relative 'view/render'
require_relative 'view/erb'
require_relative 'view/plain'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      template = render_body || File.read(template_path)

      render_class.new(template).render(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      @env['simpler.template.path'] = "#{path}.html.erb"

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def render_class
      View.const_get(@env['simpler.render'].capitalize)
    end

    def render_body
      @env['simpler.template.body']
    end

  end
end
