module AuthorsHelper
  def edit_link(author, link_options = {})
    if admin?
      link_to(link_options[:link_name] || "Edit",
        {:action => "edit", :id => author.permalink},
        {:class => "edit"})
		end
	end
end