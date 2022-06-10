# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'

require_relative '../clients/fake_eta_client'
require_relative '../clients/fake_eta_api_exception'

describe FakeEtaClient do
  before(:example) do
    @client = FakeEtaClient.new
    @target = { lat: 55.752992, lng: 37.618333 }
    @source = [{ lat: 55.7575429, lng: 37.6135117 }, { lat: 55.74837156167371, lng: 37.61180107665421 },
               { lat: 55.7532706, lng: 37.6076902 }]
  end

  it '#get_nearest_cars success' do
    stub_request = stub_request(:get, "https://dev-api.wheely.com/fake-eta/cars?lat=#{@target[:lat]}&lng=#{@target[:lng]}&limit=#{@source.count}")
                   .to_return(status: 200, body: @source.to_json)

    result = @client.get_nearest_cars(@target[:lat], @target[:lng], @source.count)

    expect(stub_request).to have_been_requested
    expect(result).to eq(@source)
  end

  it '#get_nearest_cars external error' do
    stub_request = stub_request(:get, "https://dev-api.wheely.com/fake-eta/cars?lat=#{@target[:lat]}&lng=#{@target[:lng]}&limit=#{@source.count}")
                   .to_return(status: 500)

    expect { @client.get_nearest_cars(@target[:lat], @target[:lng], @source.count) }.to raise_error(FakeEtaAPIException)
    expect(stub_request).to have_been_requested
  end

  it '#get_nearest_cars bad response data' do
    stub_request = stub_request(:get, "https://dev-api.wheely.com/fake-eta/cars?lat=#{@target[:lat]}&lng=#{@target[:lng]}&limit=#{@source.count}")
                   .to_return(status: 200, body: "'")

    expect { @client.get_nearest_cars(@target[:lat], @target[:lng], @source.count) }.to raise_error(FakeEtaAPIException)
    expect(stub_request).to have_been_requested
  end

  it '#get_arrival_times success' do
    response_body = [1, 1, 1]
    stub_request = stub_request(:post, 'https://dev-api.wheely.com/fake-eta/predict')
                   .with(body: { target: @target, source: @source })
                   .to_return(status: 200, body: response_body.to_json)

    result = @client.get_arrival_times(@target, @source)

    expect(stub_request).to have_been_requested
    expect(result).to eq(response_body)
  end

  it '#get_arrival_times external error' do
    stub_request = stub_request(:post, 'https://dev-api.wheely.com/fake-eta/predict')
                   .with(body: { target: @target, source: @source })
                   .to_return(status: 500)

    expect { @client.get_arrival_times(@target, @source) }.to raise_error(FakeEtaAPIException)

    expect(stub_request).to have_been_requested
  end

  it '#get_arrival_times bad response data' do
    stub_request = stub_request(:post, 'https://dev-api.wheely.com/fake-eta/predict')
                   .with(body: { target: @target, source: @source })
                   .to_return(status: 200, body: "'")

    expect { @client.get_arrival_times(@target, @source) }.to raise_error(FakeEtaAPIException)

    expect(stub_request).to have_been_requested
  end
end
