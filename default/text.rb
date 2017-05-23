class Text_Dictation < SpeechFamiliar::Plugin
	
	@@modifiers = []
	
	def dictation sentence
		return nil if sentence.words.length == 0
		output = ""
		Profiler.trace "context"
		parse_context sentence.words[0]
		
		sentence.words.each do |word|
		print "#{word.text} (#{word.confidence.to_string}) "
			Profiler.trace "formatting word"
			output += format(word)
		end
		
		print "\r\n"
		Automation.sendkeys output
		
		Profiler.trace "dictation finished"
		
		nil
	end
	
	def format word
		if word.properties["modifier"]
			print "modifier"
			@@modifiers << word
			
			if word.next_word
				word.next_word.last_word = word.last_word
			end
			
			return ""
		end
		
		result = word.text.to_s
		@@modifiers.each do |modifier|
			if modifier.properties["capitalize_modifier"]
				result.capitalize!
			end
			if modifier.properties["capitalize_all_modifier"]
				result.upcase!
			end
			if modifier.properties["no_capitalize_modifier"]
				result.downcase!
			end
			if modifier.properties["no_spaces_modifier"]
				word.properties.add "no_preceding_space"
			end
		end
		
		@@modifiers.clear
		
		if !word.properties["no_preceding_space"]
			result = calculate_space(word) + result# + calculate_space(word, false)
		else
			print "WOOOOW!"
		end
		
		result
	end
	
	def get_space word, default, last = true
		print "#{word.text}...#{word.properties["no_spaces"].class} #{default}"
		return 0 if word.properties["no_spaces"]
		
		if last
			return 0 if word.properties["one_following_space"]	
		else
			return 1 if word.properties["one_following_space"]	
		end
		
		default
	end
	
	def calculate_space word, last = true
		#		return "" if word.properties["no_spaces"]
		total_space = 0		
		current_space = 0
		
		pattern = /\s*\z/
		other = word.last_word
		undo = "{BACKSPACE}"
		
		if !last
			pattern = /\A\s*/
			other = word.next_word
			undo = "{DELETE}"
		end
		
		#		if total_space != 0
		if other
			match = other.text.to_s.match(pattern)[0]
			current_space = match.length if match
			total_space = get_space other, 1, last ^ true # flip 'last'
		end
		#		elsif total_space == -1
		#			total_space = 0
		
		total_space = get_space word, total_space
		
		#	. =			print "total_space = #{total_space} current_space = #{current_space}\r\n"
		if total_space > current_space
			total_space -= current_space
			return " " * total_space
		elsif current_space > total_space && total_space > 1
			total_space = current_space - total_space
			return undo * total_space			
		end
		
		""
	end
	
	def parse_context word
		Profiler.trace "context 1"
		text = Automation.get_pretext
		Profiler.trace "context 2"
	#	text = Automation.controller.get_text if text.nil?
		#		text = text.to_s
		#		print "***" +  text + "\r\n"
		return if text.nil?
		Profiler.trace "match"
		matches = System::Text::RegularExpressions::Regex.Split(text, "\\b|(?=_)|(?<=_)|(?<=[^\sA-Za-z\d])(?=[^\sA-Za-z\d])")
		#matches = System::Text::RegularExpressions::Regex.Split(text, "\\b|(?=_)|(?<=_)|(?<=[/\"\\]])(?=[/\"\\]])")
		Profiler.trace "match 1"
		words = []
		matches.each {|x| words << x.to_s }
		
		words.each_index do |y|
			x = words[y]
			if x =~ /\A\s+\z/ || x.length == 0
				words[y - 1] += x if y > 0
				words.delete(x)
				retry
			end
		end
		
		Profiler.trace "match 2"
		
		return if words.length == 0
		
		text = words[words.length - 1]
		
		result = Automation.find_word text.strip
		if result
			#			print "***" +  text + "***\r\n"
			Profiler.trace "match B"
			word.last_word = SpeechFamiliar::Token.new text, result
			Profiler.trace "match C"
		end
		#		print word.last_word.class.to_s + "\r\n"
	end
	
	def find_word text
		Automation.current_context.vocabularies.values.each do |document|
			#			print document.name.to_s + " #{document.vocabulary.count}\r\n"
			result = document.find_word text
			return result if result			
		end
		
		nil
	end
	
end
