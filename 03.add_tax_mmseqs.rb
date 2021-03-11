
hnt={}
haa={}


aa=File.open("taxonomyResult_nt.tsv").each_line do |line|
line.chomp!
hnt[line.split("\t")[0]]=line.split("\t")[3]
end
aa.close

name=''
tax=''
bb=File.open("taxonomyResult_aa.tsv").each_line do |line|
line.chomp!
haa[line.split("\t")[0]]=line.split("\t")[3]
end
bb.close

#out=File.new("diamond_firsthit_tax.txt","w")
out=File.new("diamond_kraken_catbat_mmseqs2.txt","w")
out.puts "Query\tSubject\t%identity\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tcontig_name\tdiamond_genus\tkraken_genus\tcatbat_genus\tdiamond_vs_kraken\tmmseqs_nt\tmmseqs_aa"

name=''
cc=File.open("diamond_kraken_catbat.txt").each_line do |line|
line.chomp!
#100_S101_NODE_10_11
name=line.split("\t")[0].gsub('"','')
puts name
out.puts "#{line}\t#{hnt[name]}\t#{haa[name]}"
end
cc.close







