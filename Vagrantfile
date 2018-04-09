Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/xenial64"
	config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"
	config.vm.provision "file", source: "~/sorc-vm/mainframe", destination: "$HOME/remote/mainframe"

	config.vm.provider "virtualbox" do |vb|
		vb.memory = 1524
		vb.cpus = 2
	end

	config.vm.provision "shell", path: "provision.sh"

	config.vm.synced_folder "share/", "/home/vagrant/share"
end
