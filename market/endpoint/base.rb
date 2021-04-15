class Market::Endpoint::Base
  attr_accessor :on_json_response

  def fetch!(value_to_fetch, cached_response=nil)
    find_value_in_response(cached_response || fetch_json, value_to_fetch)
  rescue StandardError => ex
    Rollbar.warning("Couldn't fetch #{value_to_fetch} from #{self.class.name}", ex: ex)
    nil
  end

  def source_url
    raise NoMethodError, 'The endpoint class must specify the source to fetch the data from'
  end

  def find_value_in_response(_json_response, _value_to_fetch)
    raise NoMethodError, 'The endpoint class must specify how to fetch the value from the json response'
  end

  private

  def fetch_json
    response      = HTTParty.get(source_url)
    json_response = JSON.parse(response.body)

    on_json_response.call(json_response) if on_json_response

    json_response
  end
end

