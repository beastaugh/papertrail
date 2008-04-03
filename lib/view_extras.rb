module ApplicationHelper
  
  def headcontent
    if RAILS_ENV == 'production'
      content_tag('script', nil, :type => 'text/javascript', :src => 'http://mint.extralogical.net/?js')
    end
  end
  
end
