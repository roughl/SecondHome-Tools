#!/bin/env ruby


class Ress
  @Name=""
  @Menge=0
  attr_writer :Name, :Menge
  attr_reader :Name, :Menge
  def initialize(name, menge)
    @Name=name
    @Menge=menge
  end
end


class Kunde
  @Name=""
  @Bezuege=[]
  @Einzahlungen=[]
  attr_reader :Bezuege, :Einzahlungen, :Name
  def initialize(name)
    @Name=name
    @Bezuege=[]
    @Einzahlungen=[]
  end
  
  def AddBezug(name, menge)
    @Bezuege.each  do |bezug|
      if bezug.Name == name
        bezug.Menge = bezug.Menge.to_i+menge.to_i
        return
      end
    end
    @Bezuege[@Bezuege.length]=Ress.new(name, menge)
    
    puts "adding #{menge} #{name} to Bezuege from customer #{@Name}"
  end
  
  def AddEinzahlung(name, menge)
    @Einzahlungen.each  do |einzahlung|
      if einzahlung.Name == name
        einzahlung.Menge = einzahlung.Menge.to_i+menge.to_i
        return
      end
    end
    @Einzahlungen[@Einzahlungen.length]=Ress.new(name, menge)
    puts "adding #{menge} #{name} to Einzahlungen from customer #{@Name}"  
  end  
end


fileName="handels_daten.txt"
if ARGV.length>=1
  fileName=ARGV[1]
end

puts fileName

file = File.new("handels_daten.txt", "r")
puts "file geöffnet"


kunden=[]

 
file.each_line() do |line|
  #puts "Got #{ line.dump }"
  
  match_name=/Eines Eurer Handelsangebote wurde angenommen. ([\w+ ]+) bezahlte/.match(line)
  
  match_bezug=/für (\d+) ([\wäöü]+)/.match(line)
  match_einzahl=/bezahlte (\d+) ([\wäöü]+)/.match(line)
  
  if match_name and match_bezug and match_einzahl
    puts "parsed: #{line}"
    name = match_name[1]
    bezug_anzahl = match_bezug[1]
    bezug_name = match_bezug[2]

    einzahl_anzahl = match_einzahl[1]
    einzahl_name = match_einzahl[2]

    puts " Kunde #{name} bezog #{bezug_anzahl} #{bezug_name}"
    puts " Kunde #{name} zahlte #{einzahl_anzahl} #{einzahl_name} ein"
    if name
      #puts name
      schon_vorhanden=false
      kundennummer=0
      for i in 0..kunden.length-1
        if kunden[i].Name()==name
          puts " kunde schon vorhanden"
          schon_vorhanden=true
          kundennummer=i
        end
      end
      if not schon_vorhanden
        puts " fÃ¼ge kunde hinzu"
        kundennummer=kunden.length
        kunden[kunden.length]=(Kunde.new(name))
      end
      kunden[kundennummer].AddBezug(bezug_name, bezug_anzahl)
      kunden[kundennummer].AddEinzahlung(einzahl_name, einzahl_anzahl)
    end
  end
end


kunden.each do |kunde|
  puts "#{kunde.Name()}:"
  puts " Bezuege:"
  kunde.Bezuege.each do |bezug|
    puts "  #{bezug.Menge} #{bezug.Name}"
  end
  puts " Einzahlungen:"
  kunde.Einzahlungen.each do |einzahlung|
    puts "  #{einzahlung.Menge} #{einzahlung.Name}"
  end
end



readline()

#File.close
