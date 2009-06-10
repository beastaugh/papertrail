class Array
  
  def literate_join(connective = ", ", last_connective = " and ")
    if self.length > 1
      last = self.pop
      return self.join(connective) + last_connective + last
    end
    
    self.first
  end
end
