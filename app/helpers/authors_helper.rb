module AuthorsHelper
  def edit_link(author, link_options = {})
    if admin?
      link_to(link_options[:link_name] || "Edit",
        {:action => "edit", :id => author.permalink},
        {:class => "edit button"})
    end
  end
  
  def author_wrapper(cache_path, &block)
    opts = {
      :cache => "authors/#{cache_path}",
      :type => "author"
    }
    
    editable_content_wrapper(opts, &block)
  end
end
