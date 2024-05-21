# encoding: UTF-8

# Copyright 2011-2013 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class PagesController < ApplicationController
  def components
    #authorize! :read, :components
    @concepts_uri = concepts_path(:format => :json)
    @concept_uri = concept_path(:id => "{id}")
  end

  def help
    authorize! :read, :help
  end

  def version
    authorize! :read, :version
  end

  def intro
  end

  def instructions
#    authorize! :read, :version
  end

end
