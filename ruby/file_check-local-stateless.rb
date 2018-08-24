#!/usr/bin/env ruby
#===============================================================================
#
#         FILE: file_check-local-stateless.rb
#
#        USAGE: ./file_check-local-stateless.rb
#
#  DESCRIPTION: An exmple of a local, stateless plugin in ruby. Checks a to see
#               a file to see if it exists, and checks the contents.
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Ryan Quinn (RQ)
# ORGANIZATION: OP5
#      VERSION: 0.0.1
#      CREATED: 08/22/2018 10:06:54 PM
#      LICENSE: MIT
#===============================================================================

# Standard libs
require 'optparse'
require 'pp'

class OptParsing
  Version = '0.0.1'

  def self.warning(arg)
    warning = arg
  end

  def self.critical(arg)
    critical = arg
  end

  def self.filepath(arg)
    filepath = arg
  end

  class ScriptOptions
    attr_accessor :verbose,
                  :delay,
                  :extension,
                  :record_separator,
                  :warning,
                  :critical,
                  :filepath


    def initialize
      self.verbose = false
      self.delay = 0
      self.warning = Hash.new
      self.critical = Hash.new
    end

    def define_options(parser)
      parser.banner = "Usage: #{$0} [options]"
      parser.separator ""
      parser.separator "Specific options:"

      verbose_enable(parser)
      exec_delay(parser)
      threshold_warning(parser)
      threshold_critical(parser)
      set_filepath(parser)

      parser.separator "Common options:"
      parser.on_tail("-h", "--help", "Show usage information.") do
        puts parser
        exit 3
      end
      parser.on_tail("-V", "--version", "Shows version number.") do
        puts Version
        exit 3
      end
    end

    def verbose_enable(parser)
      parser.on("-v", "Enable more output.") do |v|
        self.verbose = v
      end
    end

    def exec_delay(parser)
      parser.on("-d N", "--delay N", Integer, "Delays the execution of the check for X seconds.") do |n|
        self.delay = n
      end
    end

    def threshold_warning(parser)
      parser.on("-w", "--warning WARN", String, "Warning thresholds.") do |w|
        range_start, range_end = w.split(':')
        self.warning[:range_start] = range_start.to_i
        self.warning[:range_end] = range_end.to_i
      end
    end

    def threshold_critical(parser)
      parser.on("-c", "--critical CRIT", Array, "Critical thresholds.") do |c|
        range_start, range_end = c
        self.critical[:range_start] = range_start.to_i
        self.critical[:range_end] = range_end.to_i
      end
    end

    def set_filepath(parser)
      parser.on("-f", "--filepath FN", String, "Path to file.") do |f|
        self.filepath = f
      end
    end
  end

  def parse_args(args)
    @options = ScriptOptions.new
    @args = OptionParser.new do |parser|
      @options.define_options(parser)
      begin
        parser.parse!(args)
      rescue OptionParser::ParseError => error
        puts error
        puts parser
        exit 4
      end
    end
    @options
  end

  attr_reader :parser, :options
end

file_check = OptParsing.new
options = file_check.parse_args(ARGV)
pp options
pp ARGV

puts "options is type #{options.class}"
puts "options.delay: #{options.delay}"
puts "options.warning: #{options.warning}"
puts "options.critical: #{options.critical}"
puts "options.filepath: #{options.filepath}"
