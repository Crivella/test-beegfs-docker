# Docker setup to test beegs installation and operations

Used to test modification of an existing production BeeGFS from which we need to try to remove/replace nodes.
Or redeply using a different ansible script

## [Host setup]

<!-- https://github.com/RedCoolBeans/docker-beegfs -->
- Install `beegfs-client` on the host
- `cd /opt/beegfs/src/client/beegfs_client_module_XXX/build`
- `make beegfs`
- `make install`
- `modprobe beegfs`

## Notes

- Docker does not run it's own kernel, so the easiest thing before using VMs is to mount the BeeGFS module in the HOST kernel
- Containers need to run in privileged mode to be able to mount beegfs
  - Only using `CAP_SYS_ADMIN` still give a `can't mount read-only` error
- Ports must be exposed because the mounting is actually done by the host and not the container
  - Every node cannot have the same IPs for this reason
  - Every meta/storage/helperd service must be reachable by the HOST
