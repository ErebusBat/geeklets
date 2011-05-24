##
# Based on: http://www.systhread.net/texts/200703bashish.php
##

class Colors

  DULL=0
  BRIGHT=1

  FG_BLACK=30
  FG_RED=31
  FG_GREEN=32
  FG_YELLOW=33
  FG_BLUE=34
  FG_VIOLET=35
  FG_CYAN=36
  FG_WHITE=37

  FG_NULL=00

  BG_BLACK=40
  BG_RED=41
  BG_GREEN=42
  BG_YELLOW=43
  BG_BLUE=44
  BG_VIOLET=45
  BG_CYAN=46
  BG_WHITE=47

  BG_NULL=00

  ##
  # ANSI Escape Commands
  ##
  ESC=27.chr
  NORMAL="#{ESC}[m"
  RESET="#{ESC}[#{DULL};#{FG_WHITE};#{BG_NULL}m"

  ##
  # Shortcuts for Colored Text ( Bright and FG Only )
  ##

  # DULL TEXT

  BLACK="#{ESC}[#{DULL};#{FG_BLACK}m"
  RED="#{ESC}[#{DULL};#{FG_RED}m"
  GREEN="#{ESC}[#{DULL};#{FG_GREEN}m"
  YELLOW="#{ESC}[#{DULL};#{FG_YELLOW}m"
  BLUE="#{ESC}[#{DULL};#{FG_BLUE}m"
  VIOLET="#{ESC}[#{DULL};#{FG_VIOLET}m"
  CYAN="#{ESC}[#{DULL};#{FG_CYAN}m"
  WHITE="#{ESC}[#{DULL};#{FG_WHITE}m"

  # BRIGHT TEXT
  BRIGHT_BLACK="#{ESC}[#{BRIGHT};#{FG_BLACK}m"
  BRIGHT_RED="#{ESC}[#{BRIGHT};#{FG_RED}m"
  BRIGHT_GREEN="#{ESC}[#{BRIGHT};#{FG_GREEN}m"
  BRIGHT_YELLOW="#{ESC}[#{BRIGHT};#{FG_YELLOW}m"
  BRIGHT_BLUE="#{ESC}[#{BRIGHT};#{FG_BLUE}m"
  BRIGHT_VIOLET="#{ESC}[#{BRIGHT};#{FG_VIOLET}m"
  BRIGHT_CYAN="#{ESC}[#{BRIGHT};#{FG_CYAN}m"
  BRIGHT_WHITE="#{ESC}[#{BRIGHT};#{FG_WHITE}m"



  def self.test_colors
    puts "RAW, Constants:"
    puts "  normal, dull: #{Colors::RED}RED#{Colors::GREEN}green#{Colors::YELLOW}YELLOW#{Colors::BLUE}blue#{Colors::VIOLET}VIOLET#{Colors::CYAN}cyan#{Colors::WHITE}WHITE"
    puts "normal, bright: #{Colors::BRIGHT_RED}RED#{Colors::BRIGHT_GREEN}green#{Colors::BRIGHT_YELLOW}YELLOW#{Colors::BRIGHT_BLUE}blue#{Colors::BRIGHT_VIOLET}VIOLET#{Colors::BRIGHT_CYAN}cyan#{Colors::BRIGHT_WHITE}WHITE"

    puts "\n#{Colors.normal}Methods"
    puts "  normal, dull: #{Colors.red}RED#{Colors.green}green#{Colors.yellow}YELLOW#{Colors.blue}blue#{Colors.violet}VIOLET#{Colors.cyan}cyan#{Colors.white}WHITE#{Colors.normal}"
    puts "normal, bright: #{Colors.red true}RED#{Colors.green true}green#{Colors.yellow true}YELLOW#{Colors.blue true}blue#{Colors.violet true}VIOLET#{Colors.cyan true}cyan#{Colors.white true}WHITE#{Colors.normal}"
  end

  def self.normal
    NORMAL
    RESET
  end

  def self.color color, bright=false
    return NORMAL if color.to_s.empty?
    color = color.to_s.downcase.to_sym

    value = NORMAL
    case color
      when :black
        value = FG_BLACK
      when :red
        value = FG_RED
      when :green
        value = FG_GREEN
      when :yellow
        value = FG_YELLOW
      when :blue
        value = FG_BLUE
      when :violet, :purple
        value = FG_VIOLET
      when :cyan
        value = FG_CYAN
      when :white
        value = FG_WHITE
    end

    # prepend BRIGHT if needed
    value = "#{BRIGHT};#{value}" if bright
    "#{ESC}[#{value}m"
  end

  def self.black bright=false
    color :black, bright
  end
  def self.red bright=false
    color :red, bright
  end
  def self.green bright=false
    color :green, bright
  end
  def self.yellow bright=false
    color :yellow, bright
  end
  def self.blue bright=false
    color :blue, bright
  end
  def self.violet bright=false
    color :violet, bright
  end
  def self.purple bright=false
    color :purple, bright
  end
  def self.cyan bright=false
    color :cyan, bright
  end
  def self.white bright=false
    color :white, bright
  end
end