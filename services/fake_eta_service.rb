require_relative '../clients/fake_eta_client'

class FakeEtaService
  CARS_LIMIT = 3
  DEFAULT_TARGET = { lat: 55.752992, lng: 37.618333 }

  class << self
    def run_example() #looks need controller
      minutes_to_wait, errors = self.get_arrival_time(DEFAULT_TARGET)
      unless errors.empty?
        puts errors.join('\n')
        return
      end

      puts "Minimal arrive time is #{minutes_to_wait} minutes"
    end

    def get_arrival_time(target)
      sources = client.get_nearest_cars(target[:lat], target[:lng], CARS_LIMIT)
      return [nil, ['No cars near']] if sources.empty?

      arrival_times = client.get_arrival_times(target, sources)

      [arrival_times.min, nil]
    rescue FakeEtaAPIException
      return [nil, ['Something went wrong, sorry. We already fixing the problem']]
    end

    private

    def client
      @client ||= FakeEtaClient.new
    end
  end
end