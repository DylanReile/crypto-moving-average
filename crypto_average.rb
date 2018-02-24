require 'gli'
require_relative 'poloniex'

include GLI::App

program_desc 'A toolsuite for tracking crypto price averages'

desc 'Tail the one minute moving average for a given crypto pair'
command :tail do |c|
  c.flag [:s, :samples_per_minute], type: Integer, default_value: 60

  c.action do |global_options, options, args|
    help_now!('The tail command requires a crypto pair') if args.empty?
    Poloniex.display_one_minute_average(args.first, options[:samples_per_minute])
  end
end

exit run(ARGV)
