class Market::Endpoint::Bluelytics < Market::Endpoint::Base
  URL = "https://api.bluelytics.com.ar/v2/latest".freeze

  def source_url
    URL
  end

  def find_value_in_response(json_response, value_to_fetch)
    if(raw_value = json_response.fetch(value_to_fetch, {}).fetch("value_buy"))
      raw_value.to_f
    end
  end
end

