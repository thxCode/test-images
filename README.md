# Test Images Group

## Build

``` powershell

./windows/scripts/ci.ps1

```

Skip packaging `win-iis` and `win-gmsa`:

``` powershell
$DONT_PACKAGE_IMAGES="win-iis,win-gmsa"; ./windows/scripts/ci.ps1

```

Tag images to `your` repo:

``` powershell
$REPO="your"; ./windows/scripts/ci.ps1

```

## Manifest

``` powershell

$RELEASE_IDS="1809,1903"; ./windows/scripts/manifest.ps1

```

## License

Copyright (c) 2019 All Authors

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
