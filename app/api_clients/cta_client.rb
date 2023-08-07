require 'net/http'

class CtaClient
  BASE_URL = 'http://lapi.transitchicago.com/api/1.0/'

  attr_reader :api_key

  def initialize
    @api_key = Rails.application.credentials.cta[:api_key]
  end

  def arrivals(mapid)
    data = get 'ttarrivals.aspx', query: { key: api_key, mapid: }

    arrivals_data = {}
    arrivals_data[:current_time] = data[:ctatt][:tmst]
    arrivals_data[:eta] = data[:ctatt][:eta].map do |eta|
      { station_id: eta[:staId], 
        stop_id: eta[:stpId], 
        station_name: eta[:staNm], 
        stop_description: eta[:stpDe], 
        run_number: eta[:rn], 
        route_id: eta[:rt], 
        destination_stop_id: eta[:destSt], 
        destination_name: eta[:destNm], 
        direction: eta[:trDr], 
        destination_direction: eta[:destDr], 
        arrival_time: eta[:arrT], 
        prediction_generated: eta[:prdt], 
        is_approaching: eta[:isApp], 
        is_scheduled: eta[:isSch], 
        is_delayed: eta[:isDly], 
        is_fault: eta[:isFlt], 
        is_hidden: eta[:isHd], 
        minutes: eta[:min], 
        is_affected_by_layover: eta[:isSch], 
        is_affected_by_redirection: eta[:isRd], 
        is_affected_by_alternate_route: eta[:isPr],
     }
    end

    arrivals_data[:eta].each do |eta|
        current_time = Time.parse(arrivals_data[:current_time])
        arrival_time = Time.parse(eta[:arrival_time])
        time_difference = arrival_time - current_time
        minutes = ((time_difference % 3600) / 60).to_i
        seconds = (time_difference % 60).to_i
        eta[:arrival_time] = "#{minutes} minutes and #{seconds} seconds"
        eta[:formatted_arrival_time] = arrival_time.strftime("%Y%m%d %I:%M:%S %p")[-11, 11]
    end

    arrivals_data

  end

  private

  def get(path, query: {})
    make_request Net::HTTP::Get, path, query:
    # uri = URI("#{BASE_URL}#{path}")
    # uri.query = Rack::Utils.build_query(query) if query.present?
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = uri.instance_of?(URI::HTTPS)

    # request = Net::HTTP::Get.new(uri.request_uri, { 'Accept' => 'application/xml' })
    # xml_response = http.request(request)
    # response = Hash.from_xml(xml_response.body) if xml_response.body.present?
    # return if response.blank?

    # response.to_json
    # JSON.parse(response.to_json).deep_symbolize_keys
  end

  def post(path, query: {}, headers: {}, body: {})
    make_request Net::HTTP::Post, path, query:, headers:, body:
  end

  def put(path, query: {}, headers: {}, body: {})
    make_request Net::HTTP::Put, path, query:, headers:, body:
  end

  def patch(path, query: {}, headers: {}, body: {})
    make_request Net::HTTP::Patch, path, query:, headers:, body:
  end

  def delete(path, query: {})
    make_request Net::HTTP::Delete, path, query:
  end

  def make_request(klass, path, query: {}, headers: {}, body: {})
    uri = URI("#{BASE_URL}#{path}")
    uri.query = Rack::Utils.build_query(query) if query.present?
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.instance_of?(URI::HTTPS)

    request = klass.new(uri.request_uri, { 'Accept' => 'application/xml' })
    if body.present?
      request.body = body.to_json
      request['Content-Type'] = 'application/json'
    end
    xml_response = http.request(request)
    response = Hash.from_xml(xml_response.body) if xml_response.body.present?
    return if response.blank?

    response.to_json
    JSON.parse(response.to_json).deep_symbolize_keys
  end
end
