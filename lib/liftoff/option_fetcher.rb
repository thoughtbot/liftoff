module Liftoff
  class OptionFetcher
    def initialize(configuration)
      @configuration = configuration
    end

    def fetch_options
      fetch_option_for(:project_name, 'Project name')
      fetch_option_for(:company, 'Company name')
      fetch_option_for(:company_identifier, 'Company identifier')
      fetch_option_for(:prefix, 'Prefix')
    end

    private

    def fetch_option_for(attribute, prompt)
      default = @configuration.public_send(attribute)
      if !default || !@configuration.strict_prompts
        value = ask("#{prompt}? ") { |q| q.default = default }
        @configuration.public_send("#{attribute}=", value)
      end
    rescue EOFError
      puts
      fetch_option_for(attribute, prompt)
    rescue Interrupt
      exit 1
    end
  end
end
