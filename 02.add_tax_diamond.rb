
hcode={}
hcont={}
hkrcat={}

aa=File.open("code_names_kraken.txt").each_line do |line|
line.chomp!
hcode[line.split("\t")[0]]=line.split("\t")[1]
##puts hcode[line.split("\t")[0]]
end
aa.close

name=''
tax=''
bb=File.open("contigs_kraken_catbat.txt").each_line do |line|
line.chomp!
#ANP_145_NODE_15001_length_934_cov_4.576792
name=line.split("\t")[0]
tax="#{line.split("\t")[3]}\t#{line.split("\t")[4]}"
puts name
puts tax
if line =~ /\-((\d+\_NODE\_\d+)\_length\S+)/
hcont[$2]=$1
hkrcat[$2]= tax
puts $2
end
end
bb.close

#out=File.new("diamond_firsthit_tax.txt","w")
out=File.new("diamond_kraken_catbat.txt","w")
out.puts "Query\tSubject\t%identity\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore\tcontig_name\tdiamond_genus\tkraken_genus\tcatbat_genus"

name=''
cc=File.open("diamond_firsthit.txt").each_line do |line|
line.chomp!
#100_S101_NODE_10_11
if line =~ /(\d+\_).*\_(NODE\_\d+)\_/
name="#{$1}#{$2}"
#puts name
#out.puts "#{line}\t#{hcode[line.split("\|")[1]]}"
#out.puts "#{line}\t#{hcode[line.split("\|")[1]].split("\s")[0]}"
out.puts "#{line}\t#{hcont[name]}\t#{hcode[line.split("\|")[1]].split("\s")[0]}\t#{hkrcat[name]}"
end
end
cc.close







