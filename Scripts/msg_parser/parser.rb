#!/usr/bin/env ruby
#Encoding: UTF-8
require 'date'
require './handels_parser.rb'
$Debug = 0
$Version = "0.3.0"

def dputs(arg)
  if $Debug == 1
    puts arg
  end
end

def parsefile(file)
  if not file.class == File
    puts " ERROR! parsefile(<file>) <file> must be class File"
    return
  end
  start_of_message = false
  $messages = []
  message = ""
  file.each_line() do |line|
    dputs "Got " + line 

	match_von=/Botschaft von: ([\w+ ])/.match(line)
	if(match_von)
	  dputs "von hat gematcht :)"
	  start_of_message = true
	  message = ""
	end

	if start_of_message
	  message += line
	end
	  
    
    match_name=/Eines Eurer Handelsangebote wurde angenommen. ([\w+ ]+) bezahlte/.match(line)
    if not match_name
      # Ein Schmuggler von Peter Kurer ist heute bei uns eingetroffen. Er brachte uns 31000 Eisen. 
      match_name=/Ein Schmuggler von ([\w+ ]+) ist heute bei uns eingetroffen./.match(line)
    end

    match_datum=/Wurde Euch überbracht am: (\d+\. [\wäöü]+ \d+ \d+:\d+)/.match(line)
    if(match_datum)
      dputs "ein datum hat gematcht :)"
	  start_of_message = false
	  $messages << message
    end
    
    match_bezug=/für (\d+) ([\wäöü]+)/.match(line)
    match_einzahl=/bezahlte (\d+) ([\wäöü]+)/.match(line)
    
    if match_name and match_bezug and match_einzahl
      dputs "parsed: #{line}"
      name = match_name[1]
      bezug_anzahl = match_bezug[1]
      bezug_name = match_bezug[2]

      einzahl_anzahl = match_einzahl[1]
      einzahl_name = match_einzahl[2]

      dputs " Kunde #{name} bezog  #{bezug_anzahl} #{bezug_name}"
      dputs " Kunde #{name} zahlte #{einzahl_anzahl} #{einzahl_name} ein"
      if name
        puts name
        schon_vorhanden=false
        kundennummer=0
        for i in 0..$kunden.length-1
          if $kunden[i].Name()==name
            puts " kunde schon vorhanden"
            schon_vorhanden=true
            kundennummer=i
          end
        end
        if not schon_vorhanden
          dputs " füge Kunde "+name+" hinzu"
          kundennummer=$kunden.length
          $kunden[$kunden.length]=(HandelsParser::Kunde.new(name))
        end
        $kunden[kundennummer].AddBezug(bezug_name, bezug_anzahl)
	$kunden[kundennummer].SubNetto(bezug_name, bezug_anzahl)
        $kunden[kundennummer].AddEinzahlung(einzahl_name, einzahl_anzahl)
	$kunden[kundennummer].AddNetto(einzahl_name, einzahl_anzahl)
      end
    end
  end
end


$kunden=[]
fileName="handels_daten.txt"

if ARGV.length<1
  fileName="handels_daten.txt"
  puts "Parsing "+fileName
  parsefile(File.new(fileName, "r"))
else
  ARGV.each do |arg|
    if arg == "--version"
      puts $Version
      exit
    elsif arg == "--help"
      puts "usage: ./parser.rb <inputfile 1> ... <inputfile n>"
    end
    puts "Parsing "+arg
	file = File.new(arg, "r")
    parsefile(file)
	file.close
  end
end


#$messages.each do |message|
#  puts message
#  puts "------------"
#end

# print all data out
$kunden.each do |kunde|
  puts "#{kunde.Name()}:"
#  puts " Bezuege:"
#  kunde.Bezuege.each do |bezug|
#    puts "  #{bezug.Menge} #{bezug.Name}"
#  end
#  puts " Einzahlungen:"
#  kunde.Einzahlungen.each do |einzahlung|
#    puts "  #{einzahlung.Menge} #{einzahlung.Name}"
#  end
#  puts " Netto:"
  kunde.Netto.each do |netto|
    puts "  #{netto.Menge} #{netto.Name}"
  end
end
