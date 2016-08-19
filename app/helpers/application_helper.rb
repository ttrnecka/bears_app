module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "BEARS"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  # returns proper wrapper id for
  def wrapper_id
    logged_in? ? "page-wrapper" : "page-wrapper-intro"
  end
end
