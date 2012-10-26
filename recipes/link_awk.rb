case node['platform']
when 'smartos'
  link "/opt/local/bin/grep" do
    to "/opt/local/gnu/bin/awk"
    only_if { File.exists?("/opt/local/gnu/bin/awk") }
  end
end
