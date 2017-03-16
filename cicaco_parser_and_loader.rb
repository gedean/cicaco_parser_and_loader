class ImportNadiaFile
	REGEX_FUNCTION = /^FUNCTION\s(\d*)/
	REGEX_SCAN = /^Scan\s\t(\d*)/
	REGEX_RETENTION_TIME = /^Retention Time\s(\d*.\d*)/
	REGEX_WAVE_LENGTH_AND_WEIGHT = /^(\d*\.\d*)(\s)(-?\d*)/

	CSV_HEADERS = "line_number;function;scan;retention_time;wave_length;wave_weigth\n"

	def initialize filename
		@filename = filename
	end

	def import
		output_file = File.open "#{@filename}_imported.txt", "w"
		output_file.write CSV_HEADERS

		last_function_id = nil
		last_scan_id = nil
		last_retention_time = nil
		file_line_index = 0
		
		File.open(@filename).each_line do |file_line|
			file_line_index += 1
			wave_length = nil
			wave_weigth = nil
			line_buffer = []

			REGEX_FUNCTION.match(file_line) do |match|
				unless match.nil?
					last_function_id = match[1]
					next
				end
			end

			REGEX_SCAN.match(file_line) do |match|
				unless match.nil?
					last_scan_id = match[1]
					next
				end
			end

			REGEX_RETENTION_TIME.match(file_line) do |match|
				unless match.nil?
					last_retention_time = match[1]
					next
				end
			end

			REGEX_WAVE_LENGTH_AND_WEIGHT.match(file_line) do |match|
				unless match.nil?
					wave_length = match[1]
					wave_weigth = match[3]
				end
			end

			line_buffer << file_line_index
			line_buffer << last_function_id 
			line_buffer << last_scan_id
			line_buffer << last_retention_time
			line_buffer << wave_length
			line_buffer << wave_weigth
			
			output_file.write("#{line_buffer.join(";")}\r") unless line_buffer.include?(nil)

			puts "Importando linha #{file_line_index}"
		end
		output_file.close
	end
end

__END__

ImportNadiaFile.new('/vagrant/reduzido.txt').import
ImportNadiaFile.new('/vagrant/CICACO_MS1.txt').import
