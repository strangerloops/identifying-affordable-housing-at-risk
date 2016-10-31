module StabilizationCounts

  def get_stabilized_counts_for_each_sold_property

    CSV.open("stabilized/counts.csv", "w") do |csv|
      
      csv << ["bbl", 'neighborhood', "rs_count", "total_residential_count", "sale_date", "sale_price"]

      previous_bbl = ""

      boroughs.each do |borough|
        
        sales = CSV.read("filtered/#{borough}_filtered.csv", headers: true)
          .select { |sale| sale['residential_units'].to_i >= 6 }

        sales.each do |sale|
          bbl = sale['bbl']
          next unless bbl
          next if bbl == previous_bbl
          previous_bbl = bbl

          # download all the tax bills; comment the line below and uncomment the following one if you already have them
          # taxbill = download_file_from_url(taxbill_url_for(bbl), "taxbills/#{bbl}.pdf")

          # comment line above and uncomment line below if you already have the tax bills
          taxbill = File.open("taxbills/#{bbl}.pdf") rescue next

          stabilized_count_for_bbl = stabilization_count_from taxbill
          puts stabilized_count_for_bbl
          # print '.'
          csv << [bbl, sale['neighborhood'], stabilized_count_for_bbl, sale['residential_units'], sale['sale_date'], sale['sale_price']]
        end
      end
    end
  end

  def taxbill_url_for bbl
    "http://nycprop.nyc.gov/nycproperty/StatementSearch?bbl=#{bbl}&stmtDate=20160603&stmtType=SOA" 
  end

  def stabilization_count_from taxbill
    reader = PDF::Reader.new(taxbill) rescue return
    stabilization_counts = reader.pages.map do |page|
      splitext = page.text.split
      rs_count_indexes = splitext.to_enum.with_index.select{|e, _| e == "Housing-Rent"}.map(&:last).map { |index| index + 2 }
      rs_count_indexes.map { |index| splitext[index].to_i }.reduce(:+)
    end.compact.reduce(:+)
  end
end