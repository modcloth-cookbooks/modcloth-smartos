#quick and dirty fix for the yaml error

# ls /opt/local/gcc47/lib/amd64/libyaml-0.so.2 &>/dev/null || \
# ln -s /home/#{rbenv_user}/.rbenv/versions/1.9.3-p194/lib/libyaml-0.so.2.0.2 \
# /opt/local/gcc47/lib/amd64/libyaml-0.so.2

case node['platform']
when 'smartos'
  link "/opt/local/gcc47/lib/amd64/libyaml-0.so.2" do
    to "/home/ops/.rbenv/versions/1.9.3-p194/lib/libyaml-0.so.2.0.2"
    only_if { File.exists?("/home/ops/.rbenv/versions/1.9.3-p194/lib/libyaml-0.so.2.0.2") }
  end
end