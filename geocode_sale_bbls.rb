module Geocoding

  def geocode_sale_bbls
    sales = CSV.read("leverage/leverage.csv", headers: true)
    CSV.open("geocoded/geocoded.csv", 'w') do |csv|
      csv << ['bbl', 'neighborhood', 'rs_count', 'total_residential_count', 'sale_date', 'sale_price', 'stabilization', 'leverage', 'address', 'latitude', 'longitude']
      sales.each do |sale|
        location = geocode_bbl(sale['bbl'])
        sale['latitude'] = location[0]
        sale['longitude'] = location[1]
        sale['address'] = location[2]
        csv << sale
      end
    end
  end

  def geocode_bbl bbl
    print '.'
    sleep 0.15
    app_id = ENV['GEOCLIENT_ID']
    app_key = ENV['GEOCLIENT_KEY']
    base = 'https://api.cityofnewyork.us/geoclient/v1/'
    borough = boroughs_map[bbl[0]]
    block = bbl[1..5]
    lot = bbl[6..9]
    params = "bbl.json?borough=#{borough}&block=#{block}&lot=#{lot}&app_id=#{app_id}&app_key=#{app_key}"
    response = JSON.parse(Net::HTTP.get(URI.parse(URI.encode(base + params))))['bbl']
    return [0,0] unless response && response['latitudeInternalLabel'] && response['longitudeInternalLabel']
    return [0,0] unless (response['giLowHouseNumber6'] || response['giLowHouseNumber5'] || response['giLowHouseNumber4'] || response['giLowHouseNumber3'] || response['giLowHouseNumber2'] || response['giLowHouseNumber1'])
    house_number = (response['giLowHouseNumber6'] || response['giLowHouseNumber5'] || response['giLowHouseNumber4'] || response['giLowHouseNumber3'] || response['giLowHouseNumber2'] || response['giLowHouseNumber1']).strip
    street_name = (response['giStreetName6'] || response['giStreetName5'] || response['giStreetName4'] || response['giStreetName3'] || response['giStreetName2'] || response['giStreetName1']).strip
    return [0,0] unless house_number && street_name
    address = house_number + ' ' + street_name
    [response['latitudeInternalLabel'], response['longitudeInternalLabel']].map(&:to_f) << address
  end
end

# geocode_bbl "3033700059"