# This class memoizes the http response that a fetcher gets
# so if we ask the fetcher to get the price for another rate (or the
# same one again) it will not need to trigger another HTTP call.
#
class Market::CachedResponseWrapper
  def initialize(fetcher)
    @fetcher = fetcher

    @fetcher.on_json_response = lambda do |json_response|
      @cached_response = json_response
    end 
  end

  def fetch!(value_to_fetch)
    @fetcher.fetch!(value_to_fetch, @cached_response)
  end
end
