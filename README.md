# concourse-rclone-compose-resource

A Concourse CI resource that executes [`rclone`](https://rclone.org/) 
against a remote host.

See [Docker Hub](https://cloud.docker.com/repository/docker/warricksothr/concourse-rclone-resource)
for tagged image versions available.

## Resource Type Configuration

```bash
resource_types:
- name: rclone
  type: docker-image
  source:
    repository: warricksothr/concourse-rclone-resource
    tag: latest
```

## Source Configuration

* `config`: Required. The rclone config file contents to use.
* `files`: Optional. Additional files to write to the /tmp directory. This is a map of key/value pairs for the filename and contents of that file

### Example

```bash
resources:
- name: docker-compose
  type: docker-compose
  source:
    config: |
      [remote]
        client_id = <Your ID>
        client_secret = <Your Secret>
        scope = drive
        root_folder_id = <Your root folder id>
        service_account_file = /tmp/serviceAccountFile
        token = {"access_token":"XXX","token_type":"Bearer","refresh_token":"XXX","expiry":"2014-03-16T13:57:58.955387075Z"}
    files:
      serviceAccountFile: |
        ...contents...
```

### Note

It's highly recommended to use secrets mangement to avoid storing sensitive credentials in the pipeline

## Behaviour

### `check`: No-Op

### `in`: No-Op

### `out`: Execute `rclone`

#### Parameters

* `source`: Required. The path to the source files.
* `destination`: Required. The rclone destination for the files. ex. `remote:some/location`
* `subdir`: Optional. A file that includes additional path information to be appended to the end of destination.

#### Example

```bash
# Extends example in Source Configuration

jobs:
- name:
  plan:
  - do:
    - get: code # git resource
    - put: rclone
      params:
        source: code
        destination: "remote:backup"
        subdir: code/target
```

## License

Copyright 2020 Drew Short

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.