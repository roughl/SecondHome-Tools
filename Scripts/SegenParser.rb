#!/usr/bin/env ruby

$VerboseLevel=3

def verbose(level, *args)
  if level <= $VerboseLevel
    print args
  end
end


if (ARGV.size == 1)
  $filename = ARGV[0]
  verbose 1, "Reading from #{$filename}"
end

file = File.new($filename, "r")

sumNahrung=0
sumBier=0

numNahrung=Regexp.new(/[0123456789]* Nahrung/)
numBier=Regexp.new(/[0123456789]* Fass Bier/)

while line = file.gets()
  verbose(1, "parsing line: "+line)
  matchNahrung = numNahrung.match(line)
  matchBier = numBier.match(line)
  
  if matchNahrung and matchBier
    verbose 2, " got #{matchNahrung.size} match: "
    verbose 2, matchNahrung[0]+"\n"
    verbose 3, "  extracting Number: "
    verbose 3, matchNahrung[0].to_i
    verbose 3, "\n"
    sumNahrung = sumNahrung + matchNahrung[0].to_i

    verbose 2, " got #{matchBier.size} match: "
    verbose 2, matchBier[0]+"\n"
    verbose 3, "  extracting Number: "
    verbose 3, matchBier[0].to_i
    verbose 3, "\n"
    sumBier = sumBier + matchBier[0].to_i
    verbose 2, "-----------\n"
  end
end

puts "sumNahrung = #{sumNahrung}"
puts "sumBier = #{sumBier}"
