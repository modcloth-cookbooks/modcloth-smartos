case node['platform']
when 'smartos'
  link "/opt/local/bin/grep" do
    to "/opt/local/gnu/bin/grep"
    only_if { File.exists?("/opt/local/gnu/bin/grep") }
  end
end
