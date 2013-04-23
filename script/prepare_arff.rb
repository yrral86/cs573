#!/usr/bin/env ruby

dir = File.dirname __FILE__

File.open(File.join(dir, 'testfile'), 'w') { |file| file.write '' }
