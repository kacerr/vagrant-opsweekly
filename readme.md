# Opsweekly vagrant installation
```
git clone https://github.com/kacerr/vagrant-opsweekly.git
vagrant up
```

After VM is created and provisoned connect to http://localhost:8080 which is forwarded to the VM's port 80.

There is no configuration of opsweekly app, and i "hacked" getUserName function so that it always returns demo-user.


### Requirements
Reasonably current version of Vagrant (tested with 1.6.3) and Virtual Box (tested with: 4.3.2)
