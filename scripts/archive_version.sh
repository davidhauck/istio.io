#!/bin/bash

# Copyright Istio Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http:/www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Archive the current version to the archive.istio.io repo


set -e

VERSION=v
NUMBER=$(grep -w 'version:' data/args.yml | grep -oE '[^ ]+$' | tr -d '"'})
VERSION+=${NUMBER}

rm -rf public/
./scripts/gen_site.sh
./scripts/build_site.sh /${VERSION}

#issue with hugo that repeats the baseURL twice if a link is on the root: https:/github.com/okkur/syna/issues/617
find public -type f -exec sed -i "s:/${VERSION}/${VERSION}:/${VERSION}:g" {} \;

rm -rf archive.istio.io/${VERSION}
mkdir archive.istio.io/${VERSION}
mv public/* archive.istio.io/${VERSION}