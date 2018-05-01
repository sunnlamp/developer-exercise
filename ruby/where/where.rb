module Where
  def where(args = {})
    data = self
  	args.each do |key, value|

  		if value.instance_of? Regexp
  		  return data.select! { |arg| arg[key].match(value) }
  		else
  			data.select! { |arg| arg[key] == value }
  		end
  	end
    data
  end
end
