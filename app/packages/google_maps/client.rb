module GoogleMaps
  class Client
    def self.create(api_key: ENV['GOOGLE_MAPS_STATIC_API_KEY'])
      request = Koine::RestClient::Request.new(
        base_url: 'https://maps.googleapis.com/maps/api/',
        query_params: { key: api_key }
      )
      Koine::RestClient::Client.new(base_request: request)
    end
  end
end
