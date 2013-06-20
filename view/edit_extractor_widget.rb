require 'gtk3'
require_relative 'simple_combo_box.rb'
require_relative 'set_extraction_time_slider.rb'
require_relative 'building_image.rb'

# This widget provides all the options necessary to edit an Extractor.
class EditExtractorWidget < Gtk::Box
  
  attr_accessor :building_model
  
  def initialize(building_model)
	super(:vertical)
	
	# Hook up model data.
	@building_model = building_model
	
	# Gtk::Table Syntax
	# table = Gtk::Table.new(rows, columns)
	# table.attach(widget, start_column, end_column, top_row, bottom_row)  # rows and columns indexed from zero
	
	# Add planet building stats widgets in a nice grid.
	extractor_stats_table = Gtk::Table.new(7, 3)
	
	# Number of Heads Row
	number_of_heads_label = Gtk::Label.new("Number of Heads:")
	
	# Create the spin button.						# min, max, step
	@number_of_heads_spin_button = Gtk::SpinButton.new(0, 10, 1)
	@number_of_heads_spin_button.numeric = true
	
	
	
	# Extract Product Row
	extract_label = Gtk::Label.new("Extract:")
	
	@product_combo_box = SimpleComboBox.new(@building_model.accepted_product_names)
	
	
	extraction_time_label = Gtk::Label.new("Extraction Time in Hours:")
	extraction_time_label_autoadjust_warning = Gtk::Label.new("(May be auto-adjusted)")
	@extraction_time_scale = SetExtractionTimeSlider.new(@building_model)
	
	
	building_image = BuildingImage.new(@building_model)
	
	
	# Set the active iterater from the model data.
	# Since #update does this, call #update.
	update
	
	extractor_stats_table.attach(extract_label, 0, 1, 0, 1)
	extractor_stats_table.attach(@product_combo_box, 1, 2, 0, 1)
	
	extractor_stats_table.attach(number_of_heads_label, 0, 1, 1, 2)
	extractor_stats_table.attach(@number_of_heads_spin_button, 1, 2, 1, 2)
	
	extractor_stats_table.attach(extraction_time_label, 0, 1, 2, 3)
	extractor_stats_table.attach(extraction_time_label_autoadjust_warning, 0, 1, 3, 4)
	extractor_stats_table.attach(@extraction_time_scale, 1, 2, 2, 4)
	
	extractor_stats_table.attach(building_image, 2, 3, 0, 1)
	
	self.pack_start(extractor_stats_table, :expand => false)
	
	self.show_all
	
	return self
  end
  
  def start_observing_model
	@building_model.add_observer(self)
  end
  
  def stop_observing_model
	@building_model.delete_observer(self)
  end
  
  # Called when the factory_model changes.
  def update
	# Don't update the Gtk/Glib C object if it's in the process of being destroyed.
	unless (self.destroyed?)
	  @number_of_heads_spin_button.value = @building_model.extractor_heads.count
	  
	  # Set the value in the combo box to the value from the model.
	  @product_combo_box.selected_item = @building_model.product_name
	  
	  # Set the slider to the value from the model.
	  if (@building_model.extraction_time_in_hours == nil)
		@extraction_time_scale.value = 1.0
	  else
		@extraction_time_scale.value = @building_model.extraction_time_in_hours
	  end
	end
  end
  
  def commit_to_model
	self.stop_observing_model
	
	@building_model.remove_all_heads
	
	num_heads_int = @number_of_heads_spin_button.value.to_i
	num_heads_int.times do
	  @building_model.add_extractor_head
	end
	
	# Set the model to the value of the combo box.
	@building_model.product_name = @product_combo_box.selected_item
	
	# Set the extraction time to the value of the slider.
	@building_model.extraction_time_in_hours = @extraction_time_scale.value
	
	# Start observing again.
	self.start_observing_model
  end
  
  def destroy
	self.stop_observing_model
	
	self.children.each do |child|
	  child.destroy
	end
	
	super
  end
end