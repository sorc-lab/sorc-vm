Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/xenial64"
	config.vm.provider "virtualbox" do |vb|
		vb.name = "sorc-vm"
		vb.memory = 1524
		vb.cpus = 2
	end

	config.vm.provision "shell", path: "provision.sh"
end
