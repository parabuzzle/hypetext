#put things here that you want common and available to all tests

# Hack F*$#ery
$LOAD_PATH.concat(["#{Dir.pwd}/", "#{Dir.pwd}/lib"])
$LOAD_PATH.reverse!

# Define local lib base to override the installed version
# Without this, the installed libs will be loaded
# Thank you ruby for not providing load order... :-/ ~facepalm
$LIB_BASE_DIR = "#{Dir.pwd}"

# Require the libraries and test/unit
require 'test/unit'
require "#{$LIB_BASE_DIR}/lib/hypetext"

# Gather tests and run 'em
Dir.glob('./test/test*.rb').each do|test|
 puts test
 require test
end