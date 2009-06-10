# encoding: UTF-8

class String
  
  ACCENTMAP = {
    'À' => 'A',
    'Á' => 'A',
    'Â' => 'A',
    'Ã' => 'A',
    'Ä' => 'A',
    'Å' => 'AA',
    'Æ' => 'AE',
    'Ç' => 'C',
    'È' => 'E',
    'É' => 'E',
    'Ê' => 'E',
    'Ë' => 'E',
    'Ì' => 'I',
    'Í' => 'I',
    'Î' => 'I',
    'Ï' => 'I',
    'Ð' => 'D',
    'Ñ' => 'N',
    'Ò' => 'O',
    'Ó' => 'O',
    'Ô' => 'O',
    'Õ' => 'O',
    'Ö' => 'O',
    'Ø' => 'OE',
    'Ù' => 'U',
    'Ú' => 'U',
    'Ü' => 'U',
    'Û' => 'U',
    'Ý' => 'Y',
    'Þ' => 'Th',
    'ß' => 'ss',
    'à' => 'a',
    'á' => 'a',
    'â' => 'a',
    'ã' => 'a',
    'ä' => 'a',
    'å' => 'aa',
    'æ' => 'ae',
    'ç' => 'c',
    'è' => 'e',
    'é' => 'e',
    'ê' => 'e',
    'ë' => 'e',
    'ì' => 'i',
    'í' => 'i',
    'î' => 'i',
    'ï' => 'i',
    'ð' => 'd',
    'ñ' => 'n',
    'ò' => 'o',
    'ó' => 'o',
    'ô' => 'o',
    'õ' => 'o',
    'ō' => 'o',
    'ö' => 'o',
    'ø' => 'oe',
    'ù' => 'u',
    'ú' => 'u',
    'û' => 'u',
    'ū' => 'u',
    'ü' => 'u',
    'ý' => 'y',
    'þ' => 'th',
    'ÿ' => 'y',
    'Œ' => 'OE',
    'œ' => 'oe',
    '&' => 'and'
  }
  
  # Converts an input string into a URL-safe string.
  # 
  # * Leading and trailing whitespace is removed.
  # * Diacritics are removed from all characters.
  # * All letters are converted to lower case.
  # * Remaining whitespace is replaced with separators.
  # * Any remaining character which is not a letter, a digit or a valid
  # separator is removed.
  # 
  # Only underscores, dashes, plus signs and the empty string are allowed as
  # separators, although combinations are permitted, so "_", "--", "+_-" and ""
  # are all valid separators.
  def urlify(separator = "_")
    unless separator =~ /^[\-\_\+]*$/
      separator = "_"
    end
    
    self.strip.remove_subtitle.deaccentuate.downcase.gsub(/\s/, "#{separator}").gsub(/[^a-z\d\_\-\+]/, "")
  end
  
  # Removes everything from a string after the first colon
  #
  # Ensures that books with really long subtitles don't get given equally long
  # permalinks.
  def remove_subtitle
    self.split(/\s*:\s*/).first
  end
  
  # Removes diacritics from an input string's characters.
  # 
  # So a lowercase 'u' with an umlaut, ü, becomes u, while an uppercase 'A'
  # with an accute accent, Á, becomes A. This method is UTF-8 safe.
  def deaccentuate
    deaccentuated = self.split(//u).map do |x|
      unless ACCENTMAP.has_key?(x)
        x
      else
        ACCENTMAP[x]
      end
    end
    
    deaccentuated.to_s
  end
end
