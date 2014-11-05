require 'childprocess'
require 'childprocess/process'

class Server
    include Sauce::Utilities

    def self.start
      return new.start
    end

    attr_reader :port

    def start
      @port = Sauce::Config.new[:application_port]

      @server = Thread.new do
        STDERR.puts "Starting server on port #{@port}..."
        app = RackNRoll.new
        Rack::Handler::WEBrick.run app, :Port => @port
      end

      wait_for_server_on_port(@port)
      STDERR.puts "Server running."

      at_exit do
        @server.kill
      end
    end

    def stop
      begin
        @server.kill
      rescue
        STDERR.puts "Rack server could not be killed. Did it fail to start?"
      end
    end
  end
