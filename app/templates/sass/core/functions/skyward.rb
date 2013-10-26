# generator-skyward Custom Sass Functions
#
# Version: 0.2.0
# Author: Hideki Abe
#

require "sass"

module SkywardDesignFunctions
    def zeropadding(beam, i)
        assert_type beam, :Number
        assert_type i, :Number
        
        retVal = sprintf("%0" + beam.to_s + "d", i)
        Sass::Script::String.new(retVal)
    end

    def str_replace(search_cond, replace_str, str)
        assert_type search_cond, :String
        assert_type replace_str, :String
        assert_type str, :String

        if (/\/.+\// =~ search_cond.value) then
            search_cond.value.gsub!(/\//, "")
            retVal = str.value.gsub(/#{search_cond.value}/, replace_str.value)
        else
            retVal = str.value.sub(search_cond.value, replace_str.value)
        end

        Sass::Script::String.new(retVal)
    end
end

module Sass::Script::Functions
    include SkywardDesignFunctions
end