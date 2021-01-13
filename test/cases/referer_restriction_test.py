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
import requests
import base

class TestRefererRestriction(object):

    def test_blocked_refer(self):
        host = base.test_host()
        path = "/hello"
        headers = {"referer": "http://www.test.com"}
        r = requests.request("GET", url = host + path, headers = headers)
        assert r.status_code == 403

    def test_allowed_refer(self):
        host = base.test_host()
        path = "/hello"
        headers = {"referer": "http://127.0.0.1"}
        r = requests.request("GET", url = host + path, headers = headers)
        assert r.status_code == 200

    def test_empty_refer(self):
        host = base.test_host()
        path = "/hello"
        r = requests.request("GET", url = host + path)
        assert r.status_code == 403
