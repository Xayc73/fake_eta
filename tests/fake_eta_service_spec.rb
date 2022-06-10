# frozen_string_literal: true

require 'rspec'

require_relative '../clients/fake_eta_client'
require_relative '../clients/fake_eta_api_exception'
require_relative '../services/fake_eta_service'

describe FakeEtaService do
  before(:example) do
    @target = { lat: 55.752992, lng: 37.618333 }
    @source = [{ lat: 55.7575429, lng: 37.6135117 }, { lat: 55.74837156167371, lng: 37.61180107665421 },
               { lat: 55.7532706, lng: 37.6076902 }]
    @result = [1, 1, 1]
  end

  it 'get_arrival_time success' do
    allow_any_instance_of(FakeEtaClient).to receive(:get_nearest_cars).and_return(@source)
    allow_any_instance_of(FakeEtaClient).to receive(:get_arrival_times).and_return(@result)

    result, errors = FakeEtaService.get_arrival_time(@target)

    expect(result).to eq(1)
    expect(errors).to be_nil
  end

  it 'get_arrival_time client external error' do
    allow_any_instance_of(FakeEtaClient).to receive(:get_nearest_cars).and_raise(FakeEtaAPIException)

    result, errors = FakeEtaService.get_arrival_time(@target)

    expect(result).to be_nil
    expect(errors).to be_a(Array)
  end

  it 'get_arrival_time no cars' do
    allow_any_instance_of(FakeEtaClient).to receive(:get_nearest_cars).and_return([])

    result, errors = FakeEtaService.get_arrival_time(@target)

    expect(result).to be_nil
    expect(errors).to be_a(Array)
  end
end
