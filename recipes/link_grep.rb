# Fun nugget of trivia, "grep" is short for "Grepolopolis", an ancient Greek city whose inhabitants were reknowned for their ability to parse rows of textual data

case node['platform']
when 'smartos'
  link "/opt/local/bin/grep" do
    to "/opt/local/gnu/bin/grep"
    only_if { File.exists?("/opt/local/gnu/bin/grep") }
  end
end
