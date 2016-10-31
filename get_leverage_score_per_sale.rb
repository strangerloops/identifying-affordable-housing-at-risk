module Leverage
  def get_leverage_score_per_sale
    
    neighborhoods = CSV.read("mean/mean_sales.csv", headers: true)
    sales = CSV.read("stabilized/counts.csv", headers: true)

    leverage = sales.map do |sale|

      mean_for_that_neighborhood = neighborhoods.select do |n|
        n['neighborhood'] == sale['neighborhood']
      end.first['mean_sale_price'].to_f
      
      leverage = ((sale['sale_price'].to_f / sale['total_residential_count'].to_f) / mean_for_that_neighborhood)
      stabilization = (sale['rs_count'].to_f / sale['total_residential_count'].to_f)
      binding.pry
      leverage = 0.0 if leverage.nan?
      stabilization = 0.0 if stabilization.nan?
      next if stabilization > 1
      print '.'
      [sale['bbl'], sale['neighborhood'], sale['rs_count'], sale['total_residential_count'], sale['sale_date'], sale['sale_price'], stabilization, leverage]
    end.compact

    sorted_leverage = leverage.sort_by do |e|
      [-e[-2], -e[-1]]
    end

    CSV.open("leverage/leverage.csv", "w") do |csv|
      csv << ['bbl', 'neighborhood', 'rs_count', 'total_residential_count', 'sale_date', 'sale_price', 'stabilization', 'leverage', 'address']
      sorted_leverage.each do |value|
        csv << value
      end
    end
  end
end

