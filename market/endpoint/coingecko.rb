class Market::Endpoint::Coingecko < Market::Endpoint::Base
  URL = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin%2Cethereum&vs_currencies=usd".freeze

  def source_url
    URL
  end

  def find_value_in_response(json_response, value_to_fetch)
    if(raw_value = json_response.fetch(value_to_fetch, {}).fetch("usd"))
      raw_value.to_f
    end
  end
end
