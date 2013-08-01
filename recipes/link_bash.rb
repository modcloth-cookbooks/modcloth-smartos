case node['platform']
when 'smartos'
  link "/opt/local/bin/bash" do
    to "/usr/bin/bash"
    not_if { File.directory?("/opt/local/bin/bash") }
  end
end
