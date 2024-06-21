require 'erb'

class DynamicInventory
  def initialize(inventoryPath)
    @inventoryPath = inventoryPath
    @template = ERB.new <<-eof
controlplane ansible_connection=local
<% @hosts.map do |key, value| %>
<%= key %> ansible_ssh_extra_args='-o StrictHostKeyChecking=no' ansible_host=<%= value %> ansible_ssh_private_key_file=/vagrant/.vagrant/machines/<%= key %>/virtualbox/private_key<% end %>

[nodes]<% @hosts.map do |key, value| %>
<%= key %><% end %>
eof
    @hosts = {}
  end

  def createDirectory(path)
    tokens = path.split(/[\/\\]/)
    tokens.pop
    1.upto(tokens.size) do |n|
      dirs = tokens[0...n]
      dir = dirs.join('/')
      Dir.mkdir(dir) unless Dir.exist?(dir)
    end
  end

  def AddHost(name,ip)
    @hosts[name] = ip
  end

  def Generate()
    createDirectory(@inventoryPath)
    File.open(@inventoryPath, 'w') { |file| file.write(@template.result(binding)) }
  end

  def Path()
    @inventoryPath
  end
end
