# Generate HTML with table.
# Example
# a=TTH.new("UTF-8",2,[
	# ["Header1","Header2","Header3"],
	# [["CHECK",{"align"=>"center","col"=>2,"b"=>true}],"Test"],
	# ["A1","A2","A3"],
	# ["B1","B2","B3"]
# ])
# puts a.fill_html()

CONST_HTML_START	= "<!DOCTYPE HTML><html>"
CONST_HEAD_START	= "<head>"
CONST_HEAD_END		= "</head>"
CONST_BODY_START	= "<body>"
CONST_BODY_END		= "</body>"
CONST_HTML_END		= "</html>"

class TTH
	@html_data
	@meta_variable
	@data_array
	@table_data
	@table_params
	def initialize(charset_meta="utf-8",table_params={},border_size=0,data_array)
		raise StandardError.new "String is required!" unless charset_meta.is_a? String
		raise StandardError.new "Array is required!" unless data_array.is_a? Array
		@data_array		= data_array
		@table_params	= table_params
		variable_prep()
		meta_charset(charset_meta)
		create_table()
	end
	
	def variable_prep()
		@html_data		= ""
		@meta_variable	= ""
		@table_data		= ""
	end
	
	# Fill HTML using fiil_rule
	def fill_html()
		fill_rule = [CONST_HTML_START,
					CONST_HEAD_START,
					@meta_variable,
					CONST_HEAD_END,
					CONST_BODY_START,
					@table_data,
					CONST_BODY_END,
					CONST_HTML_END]
		for line in fill_rule
			@html_data += line
		end
		return @html_data
	end
	
	#All HTML5 and XML processors support UTF-8, UTF-16, Windows-1252, and ISO-8859
	# Setup charset`а
	def meta_charset(char_set)
		check_lines = ["utf-8","utf-16","windows-1252","iso-8859","ascii"]
		if check_lines.include? char_set.downcase
			@meta_variable = "<meta charset=\"#{char_set.downcase}\">"
		else
			@meta_variable = "<meta charset=\"utf-8\">"
		end
	end
	
	# Fill table
	def create_table()
		temp_table = "<table #{TableParamsToText(@table_params)}>"
		for table_object in @data_array
			temp_table += "<tr>"
			for table_lines in table_object
				if table_lines.is_a? Array
					temp_table += TextWithTags(table_lines[0],table_lines[1])
				else
					temp_table += "<td>#{table_lines}</td>"
				end
			end
			temp_table += "</tr>"
		end
		@table_data = temp_table + "</table>"
	end

	def TextWithTags(text,params)
		col_span 	= if params.include? "col" then "colspan=\"#{params["col"].to_s}\"" else "" end
		row_span 	= if params.include? "row" then "rowspan=\"#{params["row"].to_s}\"" else "" end
		align 		= if params.include? "align" then "align=\"#{params["align"].to_s}\"" else "" end
		tags_list	= ["i",
						"b",
						"small",
						"sub",
						"sup",
						"del",
						"ins",
						"mark"]
		tags_start 	= []
		tags_end 	= []
		for tag_temp in tags_list
			if params.include? tag_temp
				if params[tag_temp]==true
					tags_start.append("<"+tag_temp+">")
					tags_end.unshift("</"+tag_temp+">")
				end
			end
		end
		start_temp 	= "<td #{row_span} #{col_span} #{align}>"
		return start_temp + tags_start.join("") + text + tags_end.join("") + "</td>"
	end
	
	def TableParamsToText(params)
		temp_tags = ["align","background","bgcolor","border","bordercolor","cellpadding","cellspacing","cols","frame","height","rules","summary","width"]
		temp_text = ""
		for temp_tag in temp_tags
			if params.include? temp_tag
				temp_text += "#{temp_tag}=\"#{params[temp_tag]}\" "
			end
		end
		return temp_text
	end
end
