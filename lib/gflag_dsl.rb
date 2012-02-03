require_relative 'dsl'

module Deployment

  class GflagDSL < DSL

    def add(entry)
      case entry.values[0].to_s
        when 'yes'
          @content << entry.keys[0].to_s
        when 'no'
          @content << "no#{entry.keys[0].to_s}"
      end
    end

    def upd(entry)
      del(entry.keys[0])
      add(entry)
    end

    def del(key)
      flag = key.to_s
      noflag = "no#{flag}"
      raise "Gflag not found - #{flag}" unless @content.include? flag or @content.include? noflag
      @content.delete   flag
      @content.delete noflag
    end
  end
end