require 'PresentationFramework, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'

Window = System::Windows::Window
Controls = System::Windows::Controls
XamlReader = System::Windows::Markup::XamlReader

class Port
	attr_accessor :name, :value
	attr_accessor :direction
	attr_accessor :connections

		def initialize value_class, value_name
				@name = value_name
				@value = value_class.new
		end
end

class MetaNode
	
	@@node_list = []
	@@ports = []
	
	def initialize *items
		@ports = []
		items.each do |item|
			load_item item
		end
	end
	
	def ports
		@@ports + @ports
	end
	
	def MetaNode.add_input variable_class, variable_name
		port = add_port variable_class, variable_name
		port.direction = :input
	end
	
	def MetaNode.add_output variable_class, variable_name
		port = add_port variable_class, variable_name
		port.direction = :output
	end
	
	def render		
		#		window.show_dialog
		create_window
		#		thread = System::Threading::Thread.new { create_window }
		#		thread.name = "test";
		##		thread.set_apartment_state(System::Threading::ApartmentState.STA);
		#		thread.start();
	end
	
	def create_window
		window=XamlReader.parse <<TEXT_END
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Window1" Height="300" Width="300">
    <StackPanel x:Name="panel"></StackPanel>
</Window>
TEXT_END
		panel = window.find_name "panel"
		port_controls = Hash.new
		ports.each do |port|
			
			label = Controls::Label.new
			label.content = port.name
			panel.children.add label
			text_box = Controls::TextBox.new
			text_box.text = port.value.to_clr_string
			panel.children.add text_box
			port_controls[port.name] = text_box
		end
		
		window.topmost = true
		window.show_dialog
		port_controls.each do |port_name, control|
			eval "@#{port_name}.value = control.text.to_s"
		end
	end
	
	def run		
	end
	
	def MetaNode.inherited sub
		#		print sub.inspect
		if !@@node_list.include?(sub)
			@@node_list << sub
		end
	end
	
	def MetaNode.run_node node_name
		#		print @@node_list.length
		@@node_list.each do |node_type|
			#			print node_type.name.downcase + ", "+node_name.downcase
			if node_type.name.downcase == node_name.downcase
				node = node_type.new
				node.render
				node.run
				return
			end
		end
	end
	
	def MetaNode.types
		@@node_list
	end
	
	private
	
	def MetaNode.add_port variable_class, variable_name
		code_name = variable_name.to_s.gsub(/\s+/, "_").gsub(/\b[A-Za-z]/) { $&.capitalize }
		port = Port.new variable_class, variable_name
		@@ports << port
			eval <<TEXT_END
		@#{code_name} = port
				def #{code_name}
					@#{code_name}.value
				end
				def #{code_name}=value
					@#{code_name}.value = value
				end
TEXT_END
#			variable.extend Port
#		variable.name = variable_name
		#				@#{code_name}.extend Port
		#				@#{code_name}.name = code_name
		@@ports << port
		port
	end
	
#		# instance version	
#		def add_port variable_class, variable_name
#			code_name = variable_name.to_s.gsub(/\s+/, "_").gsub(/\b[A-Za-z]/) { $&.capitalize }
#			
#			variable = eval <<TEXT_END
#		@#{code_name} = variable_class.new
#				def self.#{code_name}
#					@#{code_name}
#				end
#				def self.#{code_name}=value
#					@#{code_name}=value
#				end
#TEXT_END
#			variable.extend Port
#			variable.name = variable_name
#			@ports << variable
#			variable
#		end
		
	def load_item item
			if item.respond_to?("each")
				return if item.length < 2
				add_port item[0], item[1]
				
			end
		end
		
end