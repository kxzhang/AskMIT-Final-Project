module ApplicationHelper

def full_title(page_title)
    base_title = "ASK MIT"
    if page_title.empty?
       base_title
    else
       "#{base_title} ! #{page_title}"
    end
end

def short_date_form(date)
	if !date.nil?
		date.strftime("%b %d")
	end
end

def long_date_form(date)
  if !date.nil?
    date.localtime().strftime("%a, %b %d, %H:%M")
  end
end

end

