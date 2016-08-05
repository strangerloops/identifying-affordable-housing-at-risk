module Utils

  def boroughs
    ['manhattan', 'bronx', 'brooklyn', 'queens', 'staten_island']
  end

  def boroughs_map
    { '1' => 'manhattan',
      '2' => 'bronx',
      '3' => 'brooklyn',
      '4' => 'queens',
      '5' => 'staten island' }
  end

  def download_file_from_url url, filename
    open(filename, 'w') do |file|
      puts "downloading #{url} to #{filename}..."
      file << open(url).read
    end
  end

  def convert_to_csv(infile, outfile)

    File.open(infile, 'r') { |f|
      if infile =~ /xlsx$/
        excel = Roo::Excelx.new(f)
      else
        excel = Roo::Excel.new(f)
      end
      out = File.open(outfile, "w")
      puts "converting #{infile} to #{outfile}..."
      5.upto(excel.last_row) do |line|
        out.write CSV.generate_line excel.row(line)
        print '.'
      end
      puts
    }
  end

  def munged_header
    ["borough", "neighborhood", "building_class_category", "tax_class_at_present", "block", "lot", "easement", "building_class_at_present", "address", "apartment_number", "zip_code", "residential_units", "commercial_units", "total_units", "land_square_feet", "gross_square_feet", "year_built", "tax_class_at_time_of_sale", "building_class_at_time_of_sale", "sale_price", "sale_date", "bbl"]
  end
end