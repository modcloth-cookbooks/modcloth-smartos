case node['platform']
when 'smartos'
  link "/opt/local/bin/whoami" do
    to "/opt/local/gnu/bin/whoami"
    only_if { File.exists?("/opt/local/gnu/bin/grep") }
  end
end
