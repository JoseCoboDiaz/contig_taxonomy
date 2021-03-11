
#`/home/josecobo/Kraken2/kraken2 --db /home/josecobo/databases/kraken2-microbial-fatfree/ shared_contigs.fasta --threads 10 --report kraken2_report.txt --out kraken2_out.txt `

hkrak={}

aa=File.open("code_names_kraken.txt").each_line do |line|	#REPORT
line.chomp!
#6	Azorhizobium
hkrak[line.split("\t")[0]]=line.split("\t")[1].split("\s")[0]
end
aa.close

puts "Contigs	ID_code	length	Taxonomy"

bb=File.open(ARGV[0]).each_line do |line|	#OUT
line.chomp!
#C	100_NODE_3501	1750719	1447	
cols=line.split("\t")
puts "#{cols[1]}\t#{cols[2]}\t#{cols[3]}\t#{hkrak[cols[2]]}"
end
bb.close
