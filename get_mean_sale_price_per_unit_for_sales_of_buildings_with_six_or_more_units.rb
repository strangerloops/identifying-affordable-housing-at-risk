module MeanPrice

  def get_mean_sale_price_per_unit_for_sales_of_buildings_with_six_or_more_units

    CSV.open("mean/mean_sales.csv", "w") do |csv|
      csv << ["neighborhood", "mean_sale_price"]

      sales = CSV.read("stabilized/counts.csv", headers: true)

      neighborhoods = sales.collect do |s|
        s["neighborhood"]
      end.uniq

      neighborhoods.each do |neighborhood|

        sales_for_neighborhood = sales.select { |sale| sale['neighborhood'] == neighborhood }

        total_price = sales_for_neighborhood.collect do |sale|
          sale['sale_price'].to_i
        end.reduce(:+)

        total_units = sales_for_neighborhood.collect do |sale|
          sale['total_residential_count'].to_i
        end.reduce(:+)

        print '.'
        
        csv << [neighborhood, (total_price / total_units rescue 0)]
      end
    end
  end
end