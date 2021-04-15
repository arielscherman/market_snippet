class Market::Endpoint::Dolarsi < Market::Endpoint::Base
  URL = "https://www.dolarsi.com/api/api.php?type=valoresprincipales".freeze

  def source_url
    URL
  end

  def find_value_in_response(json_response, value_to_fetch)
    if(raw_value = values_for_key(json_response, value_to_fetch).fetch("compra"))
      1 / parse_number(raw_value)
    end
  end

  private

  def values_for_key(json_response, key)
    json_response.map { |h| h["casa"] }.find { |h| h["nombre"] == key }.presence || {}
  end

  def parse_number(raw)
    raw.gsub(",", ".").to_f
  end
end
