#!/usr/bin/env ruby

$VERSION = "0.2.1"
$DOMKONSTANTE = 28114.29
def Provinzkosten(numProvinzen)
  kosten=0
  if numProvinzen.class == Fixnum
    if numProvinzen >20
      kosten=kosten + (numProvinzen-20)*500
    end
    if numProvinzen >30
      kosten=kosten + (numProvinzen-30)*2000
    end
    if numProvinzen >40
      kosten=kosten + (numProvinzen-40)*10000
    end
    if numProvinzen >50
      kosten=kosten + (numProvinzen-50)*50000
    end
    if numProvinzen >60
      kosten=kosten + (numProvinzen-60)*250000
    end
    if numProvinzen >70
      kosten=kosten + (numProvinzen-70)*1250000
    end
    if numProvinzen >80
      kosten=kosten + (numProvinzen-80)*6250000
    end
    
    return kosten
  else
    puts "ERROR: Provinzkosten, parameter kein int"
  end
end

$Mitglieder = 17

$AnzahlProvinzen = nil
$Einkommen = nil
$AnzahlGeistliche = 1
$AnzahlDoeme = nil
$reg_mitglieder=/\d+m/
$reg_provinzen=/\d+p/
$reg_doeme=/\d+d/
$reg_geistliche=/\d+g/
ARGV.each do |arg|
  if arg == "--version"
    puts $VERSION
    exit
  elsif $reg_mitglieder.match(arg)
    puts "mitglieder gematcht"
    $Mitglieder = arg.to_i
    puts "Es wird mit #{$Mitglieder} Allianzmitgliedern gerechnet"
  elsif $reg_provinzen.match(arg)
    puts "provinzen gematcht"
    $AnzahlProvinzen = arg.to_i
    puts "Anzahl Provinzen werden auf #{$AnzahlProvinzen} gesetzt"
  elsif $reg_doeme.match(arg)
    puts "doeme gematcht"
    $Einkommen = arg.to_i*$DOMKONSTANTE
    puts "Einkommen auf #{$Einkommen} setzen"
  elsif $reg_geistliche.match(arg)
    puts "geistliche gematcht"
    $AnzahlGeistliche = arg.to_i
  else
   puts "unbekanntes argument #{arg}"
  end
end


if $Einkommen  == nil && $AnzahlProvinzen
    puts "--- Benoetigtes Einkommen wird berechnet ---"
    provinzkosten=Provinzkosten($AnzahlProvinzen)
    puts "#{$AnzahlProvinzen} Provinzen kosten #{provinzkosten} pro Tick"
    puts "Die Gesamtkosten bei #{$Mitglieder} Mitgliedern betragen #{$Mitglieder*provinzkosten} pro Tick"
    puts "Um das zu finanzieren muessen wir #{$Mitglieder*provinzkosten/$DOMKONSTANTE/$AnzahlGeistliche} Doeme haben"
elsif $AnzahlProvinzen == nil && $Einkommen
    puts "--- Anzahl Provinzen werden gesucht ---"

    $InProTick = $Einkommen 

    puts "Wir haben ein Einkommen von #{$InProTick} pro Tick"

    provinzen=0
    until Provinzkosten(provinzen)*$Mitglieder >= $InProTick do
      provinzen=provinzen+1
    end
    provinzen-=1
    puts "#{provinzen} Provinzen pro Mitglied ergibt Gesamtkosten von #{Provinzkosten(provinzen)*$Mitglieder}"
elsif $AnzahlProvinzen && $Einkommen
  puts "--- Differenz zwischen Einkommen und Ausgaben wird berechnet ---"
  $InProTick = $Einkommen 
  puts "Wir haben ein Einkommen von #{$InProTick} pro Tick"
  kosten=Provinzkosten($AnzahlProvinzen)*$Mitglieder
  puts "Mit #{$AnzahlProvinzen} Provinzen entstehen uns Kosten von #{kosten} pro Tick, so bleibt uns #{$InProTick-kosten} pro Tick uebrig"
else
  puts "Usage: ProvinzRechner.rb [<Mitglieder>m] [<Doeme>d] [<AnzahlProvinzen>p]"
end

