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
require 'pathname'

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

    #TODO: Allow 'v' multiple times to increase the verbosity of the output.
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
        if w.include? '@'
          self.warning[:inclusive] = true
          w = w.tr('@', '')
        else
          self.warning[:inclusive] = false
        end

        if w.include? ':'
          range_start, range_end = w.split(':')
        end
        self.warning[:range_start] = range_start.to_i
        self.warning[:range_end] = range_end.to_i
        self.warning[:check] = true
      end
    end

    def threshold_critical(parser)
      parser.on("-c", "--critical CRIT", String, "Critical thresholds.") do |c|
        if c.include '@'
          self.critical[:inclusive] = true
          c = c.tr('@', '')
        else
          self.critical[:inclusive] = false
        end

        range_start, range_end = c.split(':')
        self.critical[:range_start] = range_start.to_i
        self.critical[:range_end] = range_end.to_i
        self.critical[:check] = true
      end
    end

    def set_filepath(parser)
      parser.on("-f", "--filepath FN", String, "Path to file.") do |f|
        self.filepath = File.absolute_path(f)
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
        exit 3
      end
    end
    @options
  end

  attr_reader :parser, :options
end

def check_service(options, data)
  ret_val = 3
  status = "UNKNOWN"
  description = "Service is in an unknown state."

  if data < options.warning[:range_start]
    ret_val = 0
    status = "OK"
    description = "Everything is good."
  elsif data >= options.warning[:range_start] && data < options.warning[:range_end]
    ret_val = 1
    status = "WARNING"
    description = "Service is in a warning state."
  elsif data >= options.critical[:range_start] && data < options.critical[:range_end]
    ret_val = 2
    status = "CRITICAL"
    description = "Service is in a critical state."
  end

  return ret_val, status, description
end

optionparser = OptParsing.new
options = optionparser.parse_args(ARGV)

if options.verbose
  puts "Exec delay: #{options.delay}"
  puts "Warning thresholds: #{options.warning}"
  puts "Critical thresholds: #{options.critical}"
  puts "Path to file: #{options.filepath}"
  puts ''
  pp options
  puts "ARGV dump: #{ARGV}", ''
end

file_obj = Pathname.new(options.filepath)

if file_obj.directory?
  puts "Passed file is a directory."
  exit 3
elsif !file_obj.exist?
  puts "Passed file does not exist."
  exit 3
end

data = file_obj.read
data = data.to_i

if options.verbose
  puts "Data from file: #{data}"
end

ret_val, service_status, service_description = check_service(options, data)

puts ret_val, service_status, service_description
