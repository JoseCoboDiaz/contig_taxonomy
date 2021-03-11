
#blastn -query seqs_concatenated.fasta -db ResFinder -out blastn_AR_reads.txt -outfmt '6 std stitle' -max_target_seqs 100 -perc_identity 90 -num_threads 10

name=''
tax=[]
problems=[]

out=ARGV[0].gsub(".txt","")
out1=File.new("#{out}_perfect.txt","w")
out2=File.new("#{out}_problems.txt","w")



aa=File.open(ARGV[0]).each_line do |line|
line.chomp!
#Av-FirstPlant-71_NODE_1761_length_1500_cov_31.449135_1	286	genus	Pseudomonas	-_cellular organisms;d_Bacteria;p_Proteobacteria;c_Gammaproteobacteria;o_Pseudomonadales;f_Pseudomonadaceae;g_Pseudomonas
if line =~ /^(\S+)\_\d+\s+.*g_(\w+)/
	if $1 != name
		if tax.uniq.length == 1
		out1.puts "#{name}\t#{tax[0]}"
		else
		problems << name
		puts name
		end
	name = $1
	tax = []		
	tax << $2
	else
	tax << $2
	end
end
end
aa.close

name=''

bb=File.open(ARGV[0]).each_line do |line|
line.chomp!
if line =~ /^(\S+)\_\d+\s+/
	if problems.include?($1)
		if $1 != name
		name = $1
		out2.puts "\n"
		out2.puts line
		else
		out2.puts line
		end
	end
end
end
bb.close




