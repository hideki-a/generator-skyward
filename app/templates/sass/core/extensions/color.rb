module Sass::Script
  class Color
    def to_s(opts = {})
      return rgba_str if alpha?
      return smallest if options[:style] == :compressed
      #return COLOR_NAMES_REVERSE[rgb] if COLOR_NAMES_REVERSE[rgb]
      hex_str
    end
  end
end
