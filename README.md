## Problem
1. Takes an argument for a pair of crypto currencies like ETH/BTC (Ethereum and Bitcoin)

2. Connects to the Poloniex exchange (https://poloniex.com)  

3. Calculates a 1-minute simple moving average of price for the provided token pair on an ongoing basis  

4. Displays the value in the shell while the program is running


## Installation
Ensure your environment can execute Ruby (https://rvm.io/rvm/install)

Install the Bundle dependency manager (`gem install bundler`)

Install dependencies (`bundle install`)

Execute tests (`bundle exec rspec`)

## Usage
Main functionality: `ruby crypto_average.rb tail BTC_ETH`

Optionally setting the samples per minute (default 60): `ruby crypto_average.rb tail BTC_ETH -s 120`

List the crypto pairs that Poloniex supports: `ruby crypto_average.rb list`

## Comments
1. State is scalable due to the windowing function ensuring that the maximum number of stored values is equal to samples per minute.

2. Coded in a functional style with the only mutable variables being enclosed in closures.

3. The tail command could be enchanced to accept a list of pairs. `Poloniex#display_one_minute_average` would just need to instinate lambdas for each pair and call them all in its `every_so_many_seconds` block.
