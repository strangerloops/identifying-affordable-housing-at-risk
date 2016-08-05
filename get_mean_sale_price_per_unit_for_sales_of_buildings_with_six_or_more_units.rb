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

  def get_mean_sale_price_per_unit_for_sales_of_fully_stabilized_buildings_with_six_or_more_units

    CSV.open("mean/mean_sales_stabilized.csv", "w") do |csv|
      csv << ["neighborhood", "mean_sale_price_fully_stabilized"] 
      stabilized_sales = CSV.read("stabilized/counts.csv", headers: true)
      neighborhoods = stabilized_sales.collect do |s|
        s["neighborhood"]
      end.uniq
      neighborhoods.each do |neighborhood|
        stabilized_sales_for_neighborhood = stabilized_sales.select { |sale| sale['neighborhood'] == neighborhood }
                                                            .select { |sale| ((sale['rs_count'].to_i rescue 0) / (sale['total_residential_count'].to_i rescue 0)) == 1 }

        total_price = stabilized_sales_for_neighborhood.collect do |sale|
          sale['sale_price'].to_i
        end.reduce(:+)
        total_units = stabilized_sales_for_neighborhood.collect do |sale|
          sale['total_residential_count'].to_i
        end.reduce(:+)
        print '.'
        csv << [neighborhood, (total_price / total_units rescue 0)]
      end
    end
  end

  def get_mean_sale_price_per_unit_for_sales_of_fully_market_buildings_with_six_or_more_units

    CSV.open("mean/mean_sales_market.csv", "w") do |csv|
      csv << ["neighborhood", "mean_sale_price_market"] 
      market_sales = CSV.read("stabilized/counts.csv", headers: true)
      neighborhoods = market_sales.collect do |s|
        s["neighborhood"]
      end.uniq
      neighborhoods.each do |neighborhood|
        market_sales_for_neighborhood = market_sales.select { |sale| sale['neighborhood'] == neighborhood }
                                                    .select { |sale| ((sale['rs_count'].to_i rescue 0) / (sale['total_residential_count'].to_i rescue 0)) == 0 }

        total_price = market_sales_for_neighborhood.collect do |sale|
          sale['sale_price'].to_i
        end.reduce(:+)
        total_units = market_sales_for_neighborhood.collect do |sale|
          sale['total_residential_count'].to_i
        end.reduce(:+)
        print '.'
        csv << [neighborhood, (total_price / total_units rescue 0)]
      end
    end
  end
end