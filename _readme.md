# Setup Ubuntu 16.04 to be used with Vagrant and Virtualbox

## Prepare Vagrant box with Ubuntu 16.04

We will use official box  "ubuntu/xenial64" and modify it to work with Vagrant.

* Vagrantfile

```

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true
    #
    #   # Customize the amount of memory on the VM:
    vb.memory = "1524"
  end


end

```

* run Virtual machine (VM)

```
vagrant up
```

* login to VM

```
vagrant ssh
```

### Hostname
* fix hostname in `/etc/hosts`


```
127.0.0.1 ubuntu-xenial
```

This will fix error:

```
"sudo: unable to resolve host ubuntu-xenial
```

### Rename interfaces

* login to VM (`vagrant ssh`)

* add (or modify) lines in `/etc/default/grub`

```
GRUB_CMDLINE_LINUX_DEFAULT="console=tty1 console=ttyS0 net.ifnames=0 biosdevname=0 net.ifnames=0 biosdevname=0"
GRUB_CMDLINE_LINUX=" net.ifnames=0 biosdevname=0"
```

* or update using command:

```
# 
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 net.ifnames=0 biosdevname=0\"/" /etc/default/grub

sudo sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 net.ifnames=0 biosdevname=0\"/" /etc/default/grub
```


* update

```
sudo update-grub
```

* so we will have interface named 'eth1'


* reboot VM from the host

```
vagrant reload
```


### Install python

* To use Ansible we need to install Python 2

```
sudo apt-get install python
```




# Setup VM

## Provision with Ansible


* Vagrantfile

```

Vagrant.configure(2) do |config|

  ...
  
 
  config.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true
    #
    #   # Customize the amount of memory on the VM:
    vb.memory = "1524"
  end


  config.vm.provision "ansible" do |p|
    p.playbook = "playbook.yml"
    p.verbose        = true
    p.extra_vars =
        {
            var1: "value1",
            ..
        }
  end
  
end  
```

* Ansible `playbook.yml`


```
---
- hosts: all
  sudo: true

  tasks:
    # tasks here
    

```



## hostname


* Ansible `playbook.yml`

```
---
- hosts: all
  tasks:
  
# base
#    - hostname: name={{hostname}}
    - lineinfile: dest=/etc/hosts regexp='ubuntu-xenial' line='127.0.0.1 ubuntu-xenial'       state=present
    - lineinfile: dest=/etc/hosts regexp='{{hostname}}' line='127.0.0.1 {{hostname}}' state=present
    - shell: sudo bash -c 'hostnamectl set-hostname {{hostname}}'

```

## Setup network



### Static IP
* we will add a new interface 'eth1' with static IP


* Vagrantfile

```
HOSTNAME = 'debugserver'
IP = "51.0.99.120"
NETWORK_MASK = "255.0.0.0"
NETWORK_GATEWAY = "51.0.0.1"


Vagrant.configure(2) do |config|

  ...
  
  # IP
  config.vm.network "public_network", auto_config: false, :bridge => "eth0", ip: "#{IP}"

  config.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true
    #
    #   # Customize the amount of memory on the VM:
    vb.memory = "1524"
  end


  config.vm.provision "ansible" do |p|
    p.playbook = "playbook.yml"
    p.verbose        = true
    p.extra_vars =
        {
            machine: "main",
            public_ip: IP,
            public_mask: NETWORK_MASK,
            public_gateway: NETWORK_GATEWAY,
        }
  end
  
end  

```


* Ansible playbook `playbook.yml`
 
```
---
- hosts: all
  sudo: true

  tasks:
# base
#    - hostname: name={{hostname}}
    - lineinfile: dest=/etc/hosts regexp='ubuntu-xenial' line='127.0.0.1 ubuntu-xenial'       state=present
    - lineinfile: dest=/etc/hosts regexp='{{hostname}}' line='127.0.0.1 {{hostname}}' state=present
    - shell: sudo bash -c 'hostnamectl set-hostname {{hostname}}'


# eth
    - name: stop eth1
      shell: ifdown eth1
      ignore_errors: yes

    - name: set networking
      template: src="files/interfaces/eth1.cfg.j2" dest="/etc/network/interfaces.d/eth1.cfg"

    - name: start interface
      #shell: ifup eth1 && ifdown eth1 && ifup eth1
      shell: ifup eth1
      ignore_errors: yes

    - name: restart interface
      shell: sudo ifconfig eth1 up && sudo ifconfig eth1 down && sudo ifconfig eth1 up


```

* template file for eth1.cfg `files/interfaces/eth1.cfg.j2`

```
auto eth1
iface eth1 inet static
      address {{public_ip}} 
      netmask {{public_mask}}
      {% if public_gateway is defined %}gateway {{public_gateway}} {% endif %}


```




