## vsphere_perl_sdk Cookbook

Installs the [VMware vSphere Perl SDK.](http://www.vmware.com/support/developer/viperltoolkit/)

## Usage

Download the SDK installer to your local webserver, set the appropriate attributes (as noted below) for your node, and include the `vsphere_perl_sdk` default recipe in your run_list:

```json
{
  "default_attributes": {
    "vsphere": {
      "perlsdk_eula_accepted": true,
      "perlsdk_x64_url": "http://mywebserver/vmwareinstaller.tar.gz",
      "perlsdk_x64_checksum": "5dc3klxd..."
    }
  },
  "run_list": [
    "recipe[vsphere_perl_sdk::default]"
  ]
}
```

## License and Authors
 Copyright 2014, Biola University 

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

