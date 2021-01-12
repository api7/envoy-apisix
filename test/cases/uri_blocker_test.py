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

class TestUriBlocker(object):

    def test_blocked(self):
        host = base.test_host()
        path = "/foo"
        params = {"name": "root.exe"}        
        r = requests.request("GET", url = host + path, params = params)
        print(r.text)
        # response = r.json()
        assert r.status_code == 403

    def test_not_blocked(self):
        host = base.test_host()
        path = "/foo"
        r = requests.request("GET", url = host + path)
        print(r.text)
        # response = r.json()
        # assert r.status_code == 200
        # assert response["start"] == params["start"]
        # assert response["title"] == "正在上映的电影-上海", "实际的标题是：{}".format(response["title"])
