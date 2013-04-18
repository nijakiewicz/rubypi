require "test/unit"

require_relative "../model/command_center.rb"

class TestCaseCommandCenter < Test::Unit::TestCase
  def setup
	@cc = CommandCenter.new
	@was_notified_of_change = false
  end
  
  def teardown
	# nada
  end
  
  def test_default_level_is_zero
	assert_equal(0, @cc.upgrade_level, "Default command center level is not zero.")
  end
  
  def test_level_can_be_increased
	@cc.increase_level
	assert_equal(1, @cc.upgrade_level, "Increasing a command center level did not work.")
  end
  
  def test_level_can_be_decreased
	@cc.increase_level # 1
	
	@cc.decrease_level
	assert_equal(0, @cc.upgrade_level, "Decreasing a command center level did not work.")
  end
  
  def test_level_cannot_be_increased_above_five
	@cc.increase_level # 1
	@cc.increase_level # 2
	@cc.increase_level # 3
	@cc.increase_level # 4
	@cc.increase_level # 5
	@cc.increase_level # 6!
	assert_equal(5, @cc.upgrade_level, "Increasing upgrade level 6 times does not max out at level 5.")
  end
  
  def test_level_cannot_be_decreased_below_zero
	@cc.decrease_level
	assert_equal(0, @cc.upgrade_level, "Decreasing the upgrade level from zero does not stop at zero.")
  end
  
  def test_powergrid_provided_scales_with_level
	# CC Level 0
	assert_equal(6000, @cc.powergrid_provided, "Level 0 CC powergrid is not accurate.")
	
	@cc.increase_level # 1
	assert_equal(9000, @cc.powergrid_provided, "Level 1 CC powergrid is not accurate.")
	
	@cc.increase_level # 2
	assert_equal(12000, @cc.powergrid_provided, "Level 2 CC powergrid is not accurate.")
	
	@cc.increase_level # 3
	assert_equal(15000, @cc.powergrid_provided, "Level 3 CC powergrid is not accurate.")
	
	@cc.increase_level # 4
	assert_equal(17000, @cc.powergrid_provided, "Level 4 CC powergrid is not accurate.")
	
	@cc.increase_level # 5
	assert_equal(19000, @cc.powergrid_provided, "Level 5 CC powergrid is not accurate.")
  end
  
  def test_cpu_provided_scales_with_level
	# CC Level 0
	assert_equal(1675, @cc.cpu_provided, "Level 0 CC cpu is not accurate.")
	
	@cc.increase_level # 1
	assert_equal(7057, @cc.cpu_provided, "Level 1 CC cpu is not accurate.")
	
	@cc.increase_level # 2
	assert_equal(12136, @cc.cpu_provided, "Level 2 CC cpu is not accurate.")
	
	@cc.increase_level # 3
	assert_equal(17215, @cc.cpu_provided, "Level 3 CC cpu is not accurate.")
	
	@cc.increase_level # 4
	assert_equal(21315, @cc.cpu_provided, "Level 4 CC cpu is not accurate.")
	
	@cc.increase_level # 5
	assert_equal(25415, @cc.cpu_provided, "Level 5 CC cpu is not accurate.")
  end
  
  def test_powergrid_usage_value
	assert_equal(0, @cc.powergrid_usage)
  end
  
  def test_cpu_usage_value
	assert_equal(0, @cc.cpu_usage)
  end
  
  def test_isk_cost_scales_with_level
	# CC Level 0
	assert_equal(90000.00, @cc.isk_cost, "Level 0 CC isk cost is not accurate.")
	
	@cc.increase_level # 1
	assert_equal(670000.00, @cc.isk_cost, "Level 1 CC isk cost is not accurate.")
	
	@cc.increase_level # 2
	assert_equal(1600000.00, @cc.isk_cost, "Level 2 CC isk cost is not accurate.")
	
	@cc.increase_level # 3
	assert_equal(2800000.00, @cc.isk_cost, "Level 3 CC isk cost is not accurate.")
	
	@cc.increase_level # 4
	assert_equal(4300000.00, @cc.isk_cost, "Level 4 CC isk cost is not accurate.")
	
	@cc.increase_level # 5
	assert_equal(6400000, @cc.isk_cost, "Level 5 CC isk cost is not accurate.")
  end
  
  def test_name
	assert_equal("Command Center", @cc.name)
  end
  
  def test_command_center_is_observable
	assert(@cc.is_a?(Observable), "CC did not include Observable.")
  end
  
  # Update method for testing observer.
  def update
	@was_notified_of_change = true
  end
  
  def test_command_center_notifies_observers_on_level_increase
	@cc.add_observer(self)
	
	@cc.increase_level
	assert(@was_notified_of_change, "CC did not call notify_observers or its state did not change.")
	
	@cc.delete_observer(self)
  end
  
  def test_command_center_notifies_observers_on_level_decrease
	# Have to increase before we decrease.
	@cc.increase_level
	assert_equal(false, @was_notified_of_change, "You're observing @cc before you should be. Bad tester.")
	
	# Start watching @cc. If we do it before this we get false positives.
	@cc.add_observer(self)
	
	@cc.decrease_level
	assert(@was_notified_of_change, "CC did not call notify_observers or its state did not change.")
	
	@cc.delete_observer(self)
  end
  
  def test_default_num_observers_is_zero
	assert_equal(0, @cc.count_observers)
  end
end