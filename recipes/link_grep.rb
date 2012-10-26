case node['platform']
when 'smartos'
  link "/opt/local/bin/grep" do
    to "/opt/local/bin/gnu/grep"
    only_if { File.exists?("/opt/local/bin/gnu/grep") }
  end
end
