# This class is the interface with the prices market. It is responsible for getting
# current prices for a given rate.
# It knows what sources to use for a given rate. If a rate has multiple sources defined
# it will try using the first source, and if something fails, it will continue trying
# with the other sources until a value is found (or raise if none of them work).
#
# Example:
#
#   market = Market.new
#   btc    = Rate.find_by!(key: 'btc_in_usd')
#   market.fetch_daily_value_for_rate(btc)
#
# Since there are sources that provides pricing for multiple rates, there is a caching
# mechanism (using memoization) to prevent fetching data from the same source multiple times
# when that happens.
#
# Example:
#
#   market.fetch_daily_value_for_rate(btc) # => Triggers HTTP call and caches response.
#   market.fetch_daily_value_for_rate(eth) # => Use cached response to find the price.
#
class Market
  VALUE_NOT_FOUND_ERROR_MESSAGE = "We couldn't find the value for %s on any Endpoint"

  ValueNotFoundError = Class.new(StandardError)

  # Defines what source to use to find the price for each rate (endpoint class, and
  # a key for the endpoint to use to find the price).
  #
  SOURCE_FOR_RATE_KEYS = {
    ars_in_dolar_blue:    { Endpoint::Dolarsi    => "Dolar Blue",
                            Endpoint::Bluelytics => "blue" },
    ars_in_dolar_oficial: { Endpoint::Dolarsi    => "Dolar Oficial",
                            Endpoint::Bluelytics => "oficial" },
    ars_in_dolar_ccl:     { Endpoint::Dolarsi    => "Dolar Contado con Liqui" },
    ars_in_dolar_mep:     { Endpoint::Dolarsi    => "Dolar Bolsa" },
    btc_in_usd:           { Endpoint::Coingecko  => "bitcoin" },
    eth_in_usd:           { Endpoint::Coingecko  => "ethereum" }
  }.freeze

  def fetch_daily_value_for_rate(rate)
    fetch_from_endpoint(rate) || raise(ValueNotFoundError, format(VALUE_NOT_FOUND_ERROR_MESSAGE, rate.key))
  end

  private

  def fetch_from_endpoint(rate)
    value = nil

    endpoints_for_key(rate.key.to_sym).each do |endpoint_class, endpoint_value_to_fetch|
      value = endpoint_instance_for(endpoint_class).fetch!(endpoint_value_to_fetch)
      break if value
    end

    value
  end

  def endpoints_for_key(rate_key)
    SOURCE_FOR_RATE_KEYS.fetch(rate_key)
  end

  # Returns the instance for the given endpoint (if initialized already)
  # to relay on the cached response wrapper instances so we don't trigger
  # multiple HTTP requests to the same source.
  #
  def endpoint_instance_for(klass)
    @endpoints ||= Hash.new do |h, endpoint_class|
      h[endpoint_class] = CachedResponseWrapper.new(endpoint_class.new)
    end

    @endpoints[klass]
  end
end
