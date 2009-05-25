#!/usr/bin/env ruby
#
#  release_sources.m
#  upside
#
#  Created by Victor Costan on 1/28/09.
#  Copyright Zergling.Net. All rights reserved.
#

# Enforces some source code formatting rules for upside.

Dir.glob('**/*').each do |file|
  next unless /\.m$/ =~ file or /\.h$/ =~ file  # Only Objective C code.
  next if /^ZergSupport\/TestSupport\/GTM\// =~ file  # Skip GTM code.
  next if /^ZergSupport\/TestSupport\/OCMock\// =~ file  # Skip OCMock code.
  
  contents = File.read file
  
  # eat whitespace at the end of lines
  contents.gsub! /[ \t]+$/, ""
  # tabs are 2 spaces
  contents.gsub! "\t", "  "
  
  # force -(type)method instead of - (type) method
  contents.gsub! /\-\s*\(([^(]*)\)\s*(\w)/, "-(\\1)\\2"
  contents.gsub! /\+\s*\(([^(]*)\)\s*(\w)/, "+(\\1)\\2"
  
  # force methodName:(type)argument instead of methodName: (type)argument
  contents.gsub! /(\w+)\:[ \t]*\(/, "\\1:("

  # trademarks  
  contents.gsub! '__MyCompanyName__', 'Zergling.Net'
  trademark = /^ZergSupport\// =~ file ? 'ZergSupport' : 'StockPlay'
  contents.gsub! /^\/\/  upside$/, "//  #{trademark}"

  # license
  license = /^ZergSupport\// =~ file ? 'Licensed under the MIT license.' :
                                       'All rights reserved.'
  contents.gsub! /^\/\/  Copyright.*Zergling\.Net\. .*.$/,
                 "//  Copyright Zergling.Net. #{license}"
  
  File.open(file, 'w') { |f| f.write contents }
end
