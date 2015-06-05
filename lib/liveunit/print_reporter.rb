require_relative "reporter.rb"

module LiveUnit
  ##
  #default reporter that writes results to stdout
  class PrintReporter < LiveUnit::Reporter
      def report
        results.each do |re|
          puts "Failure : " + re[:case]
          puts "Message : " + re[:msg]
          puts re[:expectation]
          #skip printing the env, too much noise
          #puts "Environment : " + re[:env].to_s
          puts
        end
      end
  end
end
