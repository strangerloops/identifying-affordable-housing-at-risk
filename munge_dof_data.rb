module Munging

  def munge_dof_data

    boroughs.each do |borough|
      puts "munging #{borough}..."
      sales = CSV.read("csv/#{borough}.csv", headers: true)

      sales.each do |sale|
        sale['NEIGHBORHOOD'] = sale['NEIGHBORHOOD'].downcase.strip
        sale['bbl'] = bbl_for sale
        binding.pry unless sale['bbl'].length == 10 # bbl oughta be 10 digits or we'll have problems.
      end

      filtered = sales.select do |sale|
        print '.'
        sale['SALE PRICE'].to_i > 0 && sale['RESIDENTIAL UNITS'].to_i >= 6
      end

      puts

      CSV.open("filtered/#{borough}_filtered.csv", "w") do |csv|
        csv << munged_header
        filtered.each do |filtered_sale|
          csv << filtered_sale
        end
      end
    end
  end

  def bbl_for sale
    (sale['BOROUGH'].to_i.to_s + sale['BLOCK'].to_i.to_s.rjust(5, "0") + sale['LOT'].to_i.to_s.rjust(4, "0")).gsub('.', '') 
  end
end