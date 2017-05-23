class Lame < MetaNode
	add_input String, :wave
	add_output String, :mp3
	
	def run
		self.mp3 = @input.gsub(/\.wav/, ".mp3")
#		puts "lame --abr 48 -m m -q 0 --resample 22.05 '#{wave_file}' '#{output}'"
		Automation.system("lame --abr 48 -m m -q 0 --resample 22.05 '#{wave}' '#{mp3}'")
	end
end