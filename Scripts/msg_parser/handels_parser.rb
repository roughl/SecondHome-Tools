
module HandelsParser
	class Bezug
	  @Name=""
	  @Menge=0
	  @Datum = Date.strptime("01.01.2009", '%d.%m.%Y')
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
	  @Netto=[]
	  attr_reader :Bezuege, :Einzahlungen, :Name, :Netto
	  def initialize(name)
		@Name=name
		@Bezuege=[]
		@Einzahlungen=[]
		@Netto=[]
	  end
	  
	  def AddBezug(name, menge)
		@Bezuege.each  do |bezug|
		  if bezug.Name == name
			bezug.Menge = bezug.Menge.to_i+menge.to_i
			return
		  end
		end
		@Bezuege[@Bezuege.length]=Bezug.new(name, menge)
		dputs "  adding #{menge} #{name} to Bezuege from customer #{@Name}"
	  end
	  
	  def AddEinzahlung(name, menge)
		@Einzahlungen.each  do |einzahlung|
		  if einzahlung.Name == name
			einzahlung.Menge = einzahlung.Menge.to_i+menge.to_i
			return
		  end
		end
		@Einzahlungen[@Einzahlungen.length]=Bezug.new(name, menge)
		dputs "  adding #{menge} #{name} to Einzahlungen from customer #{@Name}"  
	  end  

	  def AddNetto(name, menge)
		@Netto.each  do |netto|
		  if netto.Name == name
			netto.Menge = netto.Menge.to_i+menge.to_i
			return
		  end
		end
		@Netto[@Netto.length]=Bezug.new(name, menge)
		dputs "  adding #{menge} #{name} to Netto from #{@Name}"

	  end

	  def SubNetto(name, menge)
		@Netto.each  do |netto|
		  if netto.Name == name
			netto.Menge = netto.Menge.to_i-menge.to_i
			return
		  end
		end
		@Netto[@Netto.length]=Bezug.new(name, - menge.to_i)
		dputs "  adding #{menge} #{name} to Netto from #{@Name}"

	  end

	#  def CalcNetto()
	#    @Einzahlungen.each do |einzahlung|
	#      @Netto.each do |netto|
	#        if netto.Name == einzahlung.Name
	#	  netto.Menge = netto.Mengo+einzahlung.Menge
	#	else
		 
			  
	end

end

