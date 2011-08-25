module Awesomesauce
  class Filter
    def initialize(app, synonyms = [])
      @app = app
      @synonyms = Awesomesauce::Synonyms | synonyms
    end

    def call(env)
      status, headers, response = @app.call(env)
      body = ""
      response.each do |part|
        body += part.gsub(/awesome/, get_synonym)
      end

      headers["Content-Length"] = body.length
      [status, headers, body]
    end

    protected
    def get_synonym
      @synonyms[rand(@synonyms.length)]
    end
  end
end
