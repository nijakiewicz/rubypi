require "test/unit"

require_relative '../model/planet.rb'
require_relative '../model/planetary_building.rb'
require_relative '../model/production_cycle.rb'
require_relative '../model/storage_facility.rb'

class ProductionCycleStub < PlanetaryBuilding
  include ProductionCycle
end

class TestCaseProductionCycle < Test::Unit::TestCase
  # Run once.
  def self.startup
  end
  
  # Run once after all tests.
  def self.shutdown
  end
  
  # Run before every test.
  def setup
	@planet = Planet.new("Lava")
	@pcstub = ProductionCycleStub.new
	@pcstub.planet = @planet
  end
  
  # Run after every test.
  def teardown
  end
  
  
  
  # Inputs
  def test_can_set_production_cycle_input_building
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	@pcstub.production_cycle_input_building = storage_facility_a
	
	assert_equal(storage_facility_a, @pcstub.production_cycle_input_building)
	
	@pcstub.production_cycle_input_building = storage_facility_b
	
	assert_equal(storage_facility_b, @pcstub.production_cycle_input_building)
  end
  
  def test_on_set_input_building_raise_error_when_adding_building_that_doesnt_respond_to_remove_qty_of_product_method
	does_not_respond_to_remove_qty_of_product_method = ProductionCycleStub.new
	
	assert_raise ArgumentError do
	  @pcstub.production_cycle_input_building(does_not_respond_to_remove_qty_of_product_method)
	end
  end
  
  def test_can_set_production_cycle_input_to_nil
	@pcstub.production_cycle_input_building=(nil)
	
	assert_equal(nil, @pcstub.production_cycle_input_building)
  end
  
  def test_when_new_input_is_set_a_new_input_link_is_auto_created
	assert_equal(nil, @pcstub.production_cycle_input_building)
	assert_equal(nil, @pcstub.input_link)
	
	storage_facility_a = StorageFacility.new
	@pcstub.production_cycle_input_building = storage_facility_a
	
	# Make sure we have a link.
	assert_true(@pcstub.input_link.is_a?(PlanetaryLink))
	
	# Make sure we were set as the end node.
	assert_equal(@pcstub, @pcstub.input_link.end_node)
	
	# Make sure the storage facility was set as the start node.
	assert_equal(storage_facility_a, @pcstub.input_link.start_node)
  end
  
  def test_when_new_input_is_set_the_old_input_link_is_destroyed_if_any
	assert_equal(nil, @pcstub.production_cycle_input_building)
	assert_equal(nil, @pcstub.input_link)
	
	storage_facility_a = StorageFacility.new
	@pcstub.production_cycle_input_building = storage_facility_a
	
	old_link = @pcstub.input_link
	
	storage_facility_b = StorageFacility.new
	@pcstub.production_cycle_input_building = storage_facility_b
	
	new_link = @pcstub.input_link
	
	refute_equal(old_link, new_link)
	assert_equal(nil, @planet.find_link(old_link.start_node, old_link.end_node))
  end
  
  
  
  # Output
  def test_can_set_production_cycle_output_building
	storage_facility_a = StorageFacility.new
	storage_facility_b = StorageFacility.new
	
	@pcstub.production_cycle_output_building = storage_facility_a
	
	assert_equal(storage_facility_a, @pcstub.production_cycle_output_building)
	
	@pcstub.production_cycle_output_building = storage_facility_b
	
	assert_equal(storage_facility_b, @pcstub.production_cycle_output_building)
  end
  
  def test_on_set_output_building_raise_error_when_building_doesnt_respond_to_store_product_method
	does_not_respond_to_store_product_method = ProductionCycleStub.new
	
	assert_raise ArgumentError do
	  @pcstub.production_cycle_output_building=(does_not_respond_to_store_product_method)
	end
  end
  
  def test_can_set_production_cycle_output_to_nil
	@pcstub.production_cycle_output_building=(nil)
	
	assert_equal(nil, @pcstub.production_cycle_output_building)
  end
  
  def test_when_new_output_is_set_a_new_output_link_is_auto_created
	assert_equal(nil, @pcstub.production_cycle_output_building)
	assert_equal(nil, @pcstub.output_link)
	
	storage_facility_a = StorageFacility.new
	@pcstub.production_cycle_output_building = storage_facility_a
	
	# Make sure we have a link.
	assert_true(@pcstub.output_link.is_a?(PlanetaryLink))
	
	# Make sure we were set as the start node.
	assert_equal(@pcstub, @pcstub.output_link.start_node)
	
	# Make sure we were set as the end node.
	assert_equal(storage_facility_a, @pcstub.output_link.end_node)
  end
  
  def test_when_new_output_is_set_the_old_output_link_is_destroyed_if_any
	assert_equal(nil, @pcstub.production_cycle_output_building)
	assert_equal(nil, @pcstub.output_link)
	
	storage_facility_a = StorageFacility.new
	@pcstub.production_cycle_output_building = storage_facility_a
	
	old_link = @pcstub.output_link
	
	storage_facility_b = StorageFacility.new
	@pcstub.production_cycle_output_building = storage_facility_b
	
	new_link = @pcstub.output_link
	
	refute_equal(old_link, new_link)
	assert_equal(nil, @planet.find_link(old_link.start_node, old_link.end_node))
  end
  
  
  
  # Cycle Time
  def test_can_set_and_read_production_cycle_time_in_minutes
	cycles = [15, 30, 45, 60, 120, 400, 28]
	
	cycles.each do |amount|
	  @pcstub.production_cycle_time_in_minutes = (amount)
	  
	  assert_equal(amount, @pcstub.production_cycle_time_in_minutes)
	end
  end
  
  def test_can_set_and_read_production_cycle_time_in_hours
	cycles = [15, 30, 45, 60, 120, 400, 28]
	
	cycles.each do |amount|
	  @pcstub.production_cycle_time_in_hours = (amount)
	  
	  assert_equal(amount, @pcstub.production_cycle_time_in_hours)
	end
  end
  
  def test_can_set_and_read_production_cycle_time_in_days
	cycles = [15, 30, 45, 60, 120, 400, 28]
	
	cycles.each do |amount|
	  @pcstub.production_cycle_time_in_days = (amount)
	  
	  assert_equal(amount, @pcstub.production_cycle_time_in_days)
	end
  end
  
  def test_can_set_in_one_interval_and_read_in_another
	# Set in minutes, read in hours and days.
	@pcstub.production_cycle_time_in_minutes = 30
	
	assert_equal(0.5, @pcstub.production_cycle_time_in_hours)
	assert_equal(0.020833333333333332, @pcstub.production_cycle_time_in_days)
	
	# Set in hours, read in minutes and days.
	@pcstub.production_cycle_time_in_hours = 2
	
	assert_equal(120, @pcstub.production_cycle_time_in_minutes)
	assert_equal(0.083333333333333332, @pcstub.production_cycle_time_in_days)
	
	# Set in days, read in minutes and hours.
	@pcstub.production_cycle_time_in_days = 1
	
	assert_equal(1440, @pcstub.production_cycle_time_in_minutes)
	assert_equal(24, @pcstub.production_cycle_time_in_hours)
  end
end