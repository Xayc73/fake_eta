require_relative '../clients/fake_eta_client'

class FakeEtaService
  CARS_LIMIT = 3

  class << self
    def get_arrival_time(target)
      sources = client.get_nearest_cars(target[:lat], target[:lng], CARS_LIMIT)
      return [nil, ['No cars near']] if sources.empty?

      arrival_times = client.get_arrival_times(target, sources)

      [arrival_times.min, nil]
    rescue FakeEtaAPIException
      return [nil, ['Something went wrong']]
    end

    private

    def client
      @client ||= FakeEtaClient.new
    end
  end
end