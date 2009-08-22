module GraphsHelper
  
  def books_per_month_table(months)
    html = Builder::XmlMarkup.new
    
    html.table :cellspacing => 0 do
      html.tbody do
        html.tr do
          html.td "Month", :scope => "row"
        
          months.each do |month|
            html.td month[:name], :class => "month"
          end
        end
      
        html.tr do
          html.td "Number of books", :scope => "row"
        
          months.each do |month|
            html.td month[:num_books], :class => "num_books"
          end
        end
      end
    end
  end
  
end
