
#File.open("c:/temp.txt", "w") do |file|
#	local_variables.each {|text| file.write text + "\r\n" }
#	#file.write("\r\n" + included_modules)
#end

Automation = SpeechFamiliar::Scripting::Automation
Profiler = SpeechFamiliar::Profiler

def print text
	Automation.print text.to_s
end

#print Dir.getwd
load '../default/text.rb'

text = Text_Dictation.new
SpeechFamiliar::Global.plugins.add "text", text

#Ruby_Filter = SpeechFamiliar::Plugins::Ruby_Filter
#class Number_Filter < Ruby_Filter
#	def run_filter
#		sub_words.each do |item|
#			print sub_words.class
#		end
#	end
#end
#
#class Test2
#	def ruby_run
#		word.text = "Cool"
#	end
#end
#
#class Filter_Manager
#	@@filters = Hash.new
#	
#	def Filter_Manager.add key, filter
#		@@filters[key] = filter
#		Ruby_Filter.filters.add key, filter
#		filter.key = key
#	end
#	
#	def Filter_Manager.run key
#		@@filters[key].run_filter
#	end
#end
#
#Ruby_Filter.test= Test2.new
#Filter_Manager.add "number", Number_Filter.new
