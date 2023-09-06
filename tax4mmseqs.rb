aa=File.open("bactkrakDB.lookup").each_line do |line|
line.chomp!
#0	kraken:taxid|227941|NC_003361.3_1	0
puts "#{line.split("\t")[1]}\t#{line.split("\|")[1]}"
end
aa.close
