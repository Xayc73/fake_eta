# frozen_string_literal: true

require 'faraday'
require_relative 'fake_eta_api_exception'

class FakeEtaClient
  BASE_URL = 'https://dev-api.wheely.com/fake-eta'

  def initialize
    @base_url = ENV.fetch('FAKE_ETA_URL') { BASE_URL }
    @conn = Faraday.new(url: @base_url) do |faraday|
      faraday.adapter :net_http
    end
  end

  def get_nearest_cars(lat, lng, limit)
    params = {
      lat: lat,
      lng: lng,
      limit: limit
    }

    get('cars', params: params)
  end

  def get_arrival_times(target, source)
    data = { target: target, source: source }

    post('predict', data: data)
  end

  def get(relative_url, params: nil)
    make_http_request(:get, relative_url, params: params)
  end

  def post(relative_url, params: nil, data: nil)
    make_http_request(:post, relative_url, params: params, data: data)
  end

  def make_http_request(method, relative_url, params: nil, data: [])
    url = [@base_url, relative_url].join('/')
    params = {} if params.nil?
    url = "#{url}?#{URI.encode_www_form(params)}"
    body = data.to_json
    headers = default_headers

    response = @conn.run_request(method, url, body, headers)
    parse_response(response)
  end

  def default_headers
    {
      'Content-Type': 'application/json'
    }
  end

  def parse_response(response)
    begin
      parsed_result = JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError
      raise FakeEtaAPIException, response
    end
    raise FakeEtaAPIException, response if response.status >= 399

    parsed_result
  end
end
