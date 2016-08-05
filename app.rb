$LOAD_PATH << '.'

require 'open-uri'
require 'roo'
require 'roo-xls'
require 'csv'
require 'pdf-reader'
require 'pry'
require 'json'
require 'net/http'

require 'get_dof_data_as_csv.rb'
require 'munge_dof_data.rb'
require 'get_stabilized_counts_for_each_sold_property.rb'
require 'utils.rb'
require 'get_mean_sale_price_per_unit_for_sales_of_buildings_with_six_or_more_units.rb'
require 'get_leverage_score_per_sale.rb'
require 'geocode_sale_bbls.rb'

include DOF
include Munging
include StabilizationCounts
include MeanPrice
include Leverage
include Geocoding
include Utils

get_dof_data_as_csv
munge_dof_data
get_stabilized_counts_for_each_sold_property
get_mean_sale_price_per_unit_for_sales_of_buildings_with_six_or_more_units
get_leverage_score_per_sale
geocode_sale_bbls