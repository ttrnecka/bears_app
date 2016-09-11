module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = BEARS['app_name']
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
  
  def turbolinks_no_cache
    provide :turbolinks_cache do
      '<meta name="turbolinks-cache-control" content="no-cache">'.html_safe
    end
  end
end
