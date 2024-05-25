module GoogleMaps
  class Service
    def initialize(client)
      @client = client
    end

    def get_location(address:)
      client.get('/geocode/json', address:)
    end

    private

    attr_reader :client
  end
end
