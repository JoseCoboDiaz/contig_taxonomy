
#`/home/josecobo/Kraken2/kraken2 --db /home/josecobo/databases/kraken2-microbial-fatfree/ shared_contigs.fasta --threads 10 --report kraken2_report.txt --out kraken2_out.txt `

hmms={}
hdiam={}


cc=File.open("#{ARGV[0]}_mmseqs_perfect.txt").each_line do |line|
#97_NODE_4029	Rhizobacter
line.chomp!
hmms[line.split("\t")[0]]=line.split("\t")[1]
end
cc.close

cc=File.open("#{ARGV[0]}_diamond_tax_perfect.txt").each_line do |line|	
#97_NODE_4529	Aeromonas
line.chomp!
hdiam[line.split("\t")[0]]=line.split("\t")[1]
end
cc.close

out=File.new("final_tax_#{ARGV[0]}.txt","w")
out.puts "Contig\tKraken\tmmseqs\tdiamond\tconsensus"


name=''
tax=''
cc=File.open("#{ARGV[0]}_krak_tax.txt").each_line do |line|	
#93_NODE_2925	2067572	1072	Pseudomonas
line.chomp!
name=line.split("\t")[0]
tax=line.split("\t")[3]
if hmms[name] == tax
out.puts "#{name}\t#{tax}\t#{hmms[name]}\t#{hdiam[name]}\t#{tax}"
elsif hdiam[name] == tax
out.puts "#{name}\t#{tax}\t#{hmms[name]}\t#{hdiam[name]}\t#{tax}"
elsif hmms[name] == hdiam[name]
out.puts "#{name}\t#{tax}\t#{hmms[name]}\t#{hdiam[name]}\t#{hmms[name]}"
else
out.puts "#{name}\t#{tax}\t#{hmms[name]}\t#{hdiam[name]}\tunclassified"
end
end
cc.close
