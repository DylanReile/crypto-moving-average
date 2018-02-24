require 'rest-client'
require 'json'

module Poloniex
  def self.display_one_minute_average(crypto_pair, samples_per_minute)
    last_minute_average = running_average(samples_per_minute)

    every_so_many_seconds(60.0 / samples_per_minute) do
      print "\r#{last_minute_average.call(current_price(crypto_pair))}"
    end
  end

  def self.display_supported_pairs
    puts current_pair_data.keys
  end

  def self.current_price(crypto_pair)
    pair = current_pair_data[crypto_pair]
    raise ArgumentError, "#{crypto_pair} not supported by Poloniex" if pair.nil?
    pair["last"].to_f
  end

  def self.current_pair_data
    response = RestClient.get('https://www.poloniex.com/public', params: { command: 'returnTicker' })
    JSON.parse(response)
  end

  def self.running_average(window)
    count = 0
    avg = 0.0
    samples = []

    lambda do |last|
      count += 1
      samples << last
      avg += (last-avg)/count

      # shift the start of the window rightward
      if count > window
        count -= 1
        avg -= (samples.shift-avg)/count
      end

      return avg
    end
  end

  private_class_method def self.every_so_many_seconds(seconds)
    # Simply sleeping for seconds before yielding would cause drift since:
    #   A.) The yielded-to block has a nonzero runtime.
    #   B.) There's no gurantee that the CPU will return priority at exact intervals.
    last_tick = Time.now
    loop do
      sleep 0.1
      if Time.now - last_tick >= seconds
        last_tick += seconds
        yield
      end
    end
  end
end
