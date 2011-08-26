module Awesomesauce
  class Filter
    def initialize(app, synonyms = [])
      @app = app
      @synonyms = Awesomesauce::Synonyms | synonyms
    end

    def call(env)
      status, headers, response = @app.call(env)
      response.each do |part|
        while part.match(/(A|a)wesome/)
          part.sub! /(A|a)wesome[a-z]*/ do |match|
            puts match.class
            match[0] == "A" ? get_synonym.capitalize : get_synonym
          end
        end
      end

      headers["Content-Length"] = response.join.length.to_s
      [status, headers, response]
    end

    protected
    def get_synonym
      @synonyms[rand(@synonyms.length)]
    end
  end
end
