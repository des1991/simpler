require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.render'] = 'erb'

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def params
      @request.env['simpler.params'].merge(@request.params)
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template.is_a?(Hash)
        @request.env['simpler.render'] = template.first[0]
        @request.env['simpler.template.body'] = template.first[1]
      else
        @request.env['simpler.template'] = template
      end
    end

    def status(code)
      @response.status = code
    end

    def headers
      @response
    end

  end
end
