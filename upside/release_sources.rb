Dir.glob('**/*').each do |file|
  next unless /\.m$/ =~ file or /\.h$/ =~ file
  
  contents = File.read file
  
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
