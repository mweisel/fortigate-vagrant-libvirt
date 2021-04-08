<img alt="Vagrant" src="https://img.shields.io/badge/vagrant%20-%231563FF.svg?&style=for-the-badge&logo=vagrant&logoColor=white"/>

# Fortinet FortiGate Vagrant box

A Packer template for creating a Fortinet FortiGate Vagrant box for the [libvirt](https://libvirt.org) provider.

## Prerequisites

  * [Fortinet](https://support.fortinet.com) account
  * [Git](https://git-scm.com)
  * [Packer](https://packer.io) >= 1.70
  * [libvirt](https://libvirt.org)
  * [QEMU](https://www.qemu.org)
  * [Vagrant](https://www.vagrantup.com) <= 2.2.9
  * [vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)

## Steps

0\. Verify the prerequisite tools are installed.

<pre>
$ <b>which git unzip packer libvirtd qemu-system-x86_64 vagrant</b>
$ <b>vagrant plugin list</b>
vagrant-libvirt (0.4.0, global)
</pre>

1\. Log in and download the FortiGate-VM virtual appliance deployment package from [Fortinet](https://docs.fortinet.com/document/fortigate/6.0.0/fortigate-vm-on-kvm/961760/downloading-the-fortigate-vm-virtual-appliance-deployment-package). Save the file to your `Downloads` directory.

2\. Extract the disk image file to the `/var/lib/libvirt/images` directory.

<pre>
$ <b>cd $HOME/Downloads</b>
$ <b>sudo unzip -d /var/lib/libvirt/images FGT_VM64_KVM-v6-build1828-FORTINET.out.kvm.zip</b>
</pre>

3\. Modify the file ownership and permissions. Note the owner may differ between Linux distributions.

> Ubuntu 18.04

<pre>
$ <b>sudo chown libvirt-qemu:kvm /var/lib/libvirt/images/fortios.qcow2</b>
$ <b>sudo chmod u+x /var/lib/libvirt/images/fortios.qcow2</b>
</pre>

> Arch Linux

<pre>
$ <b>sudo chown nobody:kvm /var/lib/libvirt/images/fortios.qcow2</b>
$ <b>sudo chmod u+x /var/lib/libvirt/images/fortios.qcow2</b>
</pre>

4\. Create the `boxes` directory.

<pre>
$ <b>mkdir -p $HOME/boxes</b>
</pre>

5\. Clone this GitHub repo and _cd_ into the directory.

<pre>
$ <b>git clone https://github.com/mweisel/fortigate-vagrant-libvirt</b>
$ <b>cd fortigate-vagrant-libvirt</b>
</pre>

6\. Packer _build_ to create the Vagrant box artifact. Supply the FortiOS version number for the `version` variable value.

<pre>
$ <b>packer build -var 'version=6.4.5' fortigate.pkr.hcl</b>
</pre>

7\. Copy the Vagrant box artifact to the `boxes` directory.

<pre>
$ <b>cp ./builds/fortinet-fortigate-6.4.5.box $HOME/boxes/</b>
</pre>

8\. Copy the box metadata file to the `boxes` directory.

<pre>
$ <b>cp ./src/fortigate.json $HOME/boxes/</b>
</pre>

9\. Change the current working directory to `boxes`.

<pre>
$ <b>cd $HOME/boxes</b>
</pre>

10\. Substitute the `HOME` placeholder string in the box metadata file.

<pre>
$ <b>awk '/url/{gsub(/^ */,"");print}' fortigate.json</b>
"url": "file://<b>HOME</b>/boxes/fortinet-fortigate-VER.box"

$ <b>sed -i "s|HOME|${HOME}|" fortigate.json</b>

$ <b>awk '/url/{gsub(/^ */,"");print}' fortigate.json</b>
"url": "file://<b>/home/marc</b>/boxes/fortinet-fortigate-VER.box"
</pre>

11\. Also, substitute the `VER` placeholder string with the FortiOS version you're using.

<pre>
$ <b>awk '/VER/{gsub(/^ */,"");print}' fortigate.json</b>
"version": "<b>VER</b>",
"url": "file:///home/marc/boxes/fortinet-fortigate-<b>VER</b>.box"

$ <b>sed -i 's/VER/6.4.5/g' fortigate.json</b>

$ <b>awk '/\&lt;version\&gt;|url/{gsub(/^ */,"");print}' fortigate.json</b>
"version": "<b>6.4.5</b>",
"url": "file:///home/marc/boxes/fortinet-fortigate-<b>6.4.5</b>.box"
</pre>

12\. Add the Vagrant box to the local inventory.

<pre>
$ <b>vagrant box add fortigate.json</b>
</pre>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
