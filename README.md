# Operation

## Starting docker compose

```bash
docker compose up
```

## Vagrant Cluster

Vagrant configuration:

The cluster consists of:

- 1 **control node** (`ctrl`) – 192.168.56.100
- N **worker nodes** (`node-1`, `node-2`, ...) – 192.168.56.10X

Base image: `bento/ubuntu-24.04`

### Start the cluster

From the `vagrant/` directory: (`cd vagrant/`)

```bash
# Start with 2 workers (default)
vagrant up

# Start with custom number of workers
NUM_WORKERS=3 vagrant up

# Stop and destroy
vagrant destroy -f

# Control node
vagrant ssh ctrl

# First worker node
vagrant ssh node-1

# Second worker node (if exists)
vagrant ssh node-2
```

If you want to connect to the VMs without using `vagrant ssh` you need to add your public ssh key in `ansible/ssh_keys` and then rerun vagrant.

After this step you should be able to connect to the VM using:
```bash
ssh -i ~/.ssh/<RESPECTIVE PRIVATE SSH KEY> vagrant@192.168.56.10X
``
