# During the dark days of the great GNU v. System V wars.... three awks were forged... each more powerful than the last.

case node['platform']
when 'smartos'
  link "/opt/local/bin/awk" do
    to "/opt/local/gnu/bin/awk"
    only_if { File.exists?("/opt/local/gnu/bin/awk") }
  end
end
