class ApplicationController < ActionController::Base
  require 'net/http'
  require 'json'

  before_action :test

  def test
    puts params['from']
    puts params['to']
  end

  def index
    @cryptocurrencies = cryptocurrencies
  end

  def show
    @cryptocurrencies = cryptocurrencies
    @count = params['count'].blank? ? 1 : params['count'].to_f
    # @from = eval(params['from'])
    # @to = eval(params['to'])
    # @result = @count * @from['price_usd'].to_f / @to['price_usd'].to_f
    #
    # chart(@from, @to)
    render "application/index"
  end

  def get_crypto(ticker)
    cryptocurrencies.find { |crypto| crypto['symbol'] == ticker.upcase }
  end

  def cryptocurrencies
    url = 'https://api.coinmarketcap.com/v1/ticker/'
    parse_json(url).sort { |a, b| a['name'].downcase <=> b['name'].downcase }
  end

  def chart(from, to)
    from_url = "https://min-api.cryptocompare.com/data/histoday?fsym=#{from['symbol']}&tsym=USD&limit=60&aggregate=1&e=CCCAGG"
    to_url = "https://min-api.cryptocompare.com/data/histoday?fsym=#{to['symbol']}&tsym=USD&limit=60&aggregate=1&e=CCCAGG"
    from_response = parse_json(from_uri)
    to_response = parse_json(to_uri)

    from_response.each { |data| puts data['close'] }
  end

  def parse_json(url)
    uri = URI(url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
