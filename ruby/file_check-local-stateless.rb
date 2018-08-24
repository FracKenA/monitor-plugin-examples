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

  class ScriptOptions
    attr_accessor :verbose,
                  :delay,
                  :extension,
                  :record_separator

    def initialize
      self.verbose = false
    end

    def define_options(parser)
      parser.banner = "Usage: #{$0} [options]"
      parser.separator ""
      parser.separator "Specific options:"

      verbose_enable(parser)
      exec_delay(parser)
      threshold_warning(parser)

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
      parser.on("-w warn", "--warning warn", Array, "Warning thresholds.") do |w|
        puts w
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

