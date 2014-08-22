#!/usr/bin/env bats

@test "vsphere cli uninstall binary is found in PATH" {
  run which vmware-uninstall-vSphere-CLI.pl
  [ "$status" -eq 0 ]
}
