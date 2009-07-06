module GraphsHelper
  
  def yearly_graph(months, options = {})
    bar_height = options[:maxheight] * 20 || 177
    
    xml = Builder::XmlMarkup.new
    xml.svg :xmlns => "http://www.w3.org/2000/svg", "xmlns:xlink" => "http://www.w3.org/1999/xlink",
            :width => 520, :height => bar_height + 20, :zoomAndPan => "disable" do
            
      xml.rect :x => 0, :y => 0, :width => 520, :height => bar_height + 20, :fill => "#1a1a1a"
      
      months.each_with_index do |month, num|
        height = month[:books] * 20
        xml.g :id => "#{Time::RFC2822_MONTH_NAME[month[:month] - 1].to_s.downcase}-books-height",
              :transform => "translate(#{num * 43.5} 0)" do
          xml.rect :x => 0, :y => bar_height - height,
                   :width => 41.5, :height => height + 1, :fill => "#212325"
          xml.text Time::RFC2822_MONTH_NAME[month[:month] - 1], :x => 8, :y => bar_height + 17,
                   :style => "font-family:Helvetica, Arial, sans-serif; font-size:12px; fill:#ccc;"
        end
      end
    end
  end
  
end
