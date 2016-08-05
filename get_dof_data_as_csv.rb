module DOF

  def get_dof_data_as_csv

    urls = {
      manhattan: "https://www1.nyc.gov/assets/finance/downloads/pdf/rolling_sales/rollingsales_manhattan.xls",
      bronx: "https://www1.nyc.gov/assets/finance/downloads/pdf/rolling_sales/rollingsales_bronx.xls",
      brooklyn: "https://www1.nyc.gov/assets/finance/downloads/pdf/rolling_sales/rollingsales_brooklyn.xls",
      queens: "https://www1.nyc.gov/assets/finance/downloads/pdf/rolling_sales/rollingsales_queens.xls",
      staten_island: "https://www1.nyc.gov/assets/finance/downloads/pdf/rolling_sales/rollingsales_statenisland.xls"
    }

    urls.keys.each do |borough|
      url = urls[borough]
      download_file_from_url(url, "xls/#{borough}.xls")
    end

    urls.keys.each do |borough|  
      convert_to_csv("xls/#{borough}.xls", "csv/#{borough}.csv")
    end
  end
end