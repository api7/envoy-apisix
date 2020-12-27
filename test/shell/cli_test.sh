#!/usr/bin/env bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -ex


# validate uri-blocker
code=$(curl -v -k -i -m 20 -o /dev/null -s -w %{http_code} http://127.0.0.1:8000/foo/root.exe)

if [ ! $code -eq 403 ]; then
    echo "failed: uri block failed"
    exit 1
fi

code=$(curl -v -k -i -m 20 -o /dev/null -s -w %{http_code} http://127.0.0.1:8000/foo?name=root.exe)

if [ ! $code -eq 403 ]; then
    echo "failed: uri block failed"
    exit 1
fi

#  validate ip-restriction
code=$(curl -v -k -i -m 20 -o /dev/null -s -w %{http_code} http://127.0.0.1:8000/ip)

if [ ! $code -eq 403 ]; then
    echo "failed: ip restriction failed"
    exit 1
fi


#  validate redirect
code=$(curl -v -k -i -m 20 -o /dev/null -s -w %{http_code} http://127.0.0.1:8000/bar)

if [ ! $code -eq 301 ]; then
    echo "failed: ip restriction failed"
    exit 1
fi
