class CloudLog
    def run
        options = {}
        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: vapor-alpha cloud logs [options]"
          opts.separator  ""
          opts.separator  "Options"
          opts.on('-a', '--app APP', 'Application slug') { |v| options[:app] = v }
          opts.on('-e', '--env ENVIRONMENT', 'Application environment') { |v| options[:env] = v }
        end

        opt_parser.parse!

        unless options[:app]
            puts opt_parser
            exit
        end

        unless options[:env]
            puts opt_parser
            exit
        end

        prompt = TTY::Prompt.new

        spinner = TTY::Spinner.new("[:spinner] Fetching logs ...")

        object = {
            application: options[:app],
            environment: options[:env]
        }

        spinner.auto_spin
        output = VCloud::Helper::Api::Post::new::call("v2/replica/logs", object, true)
        spinner.stop('Done!')

        data = JSON.parse(output.body)

        id = data['id']
        app = options[:app]

        CloudSocket::new::run("#{id}", "#{app}")
    end
end
