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

#Derived from hierarchy_controller.rb
class Concepts::OpenactiveController < ConceptsController

  def index
    authorize! :read, Iqvoc::Concept.base_class

    scope = Iqvoc::Concept.base_class
    scope = scope.published

    # only select unexpired concepts
    # TODO decide handling of expired concepts for OA list
    scope = scope.published.not_expired.includes(:broader_relations, :narrower_relations, :notes, :notations, :alt_labels, :pref_labels)

    @concepts = scope

    @collections = Iqvoc::Collection.base_class.published.includes(:members, :notes, :alt_labels, :pref_labels)

    # When in single query mode, AR handles ALL includes to be loaded by that
    # one query. We don't want that! So let's do it manually :-)
    #    ActiveRecord::Associations::Preloader.new.preload(@concepts,
    #        Iqvoc::Concept.base_class.default_includes + [])

    @concepts.to_a.sort_by! {|c| c.pref_label }

    respond_to do |format|
      format.jsonld do

        # Create main unvalidated_activity_list.jsonld file (which is then validated by CI within the activity-list repo)

        concepts = @concepts.select { |c| can? :read, c }.map do |c|
          url = "https://disability.openactive.io/participant-condition-supported##{c.origin[1..-1]}"
    #      definition = c.notes_for_class(Note::SKOS::Definition).empty? ? "" : c.notes_for_class(Note::SKOS::Definition).first.value
          broader = []
          c.broader_relations.each do |rel|
            broader << "https://disability.openactive.io/participant-condition-supported##{rel.target.origin[1..-1]}"
          end
          narrower = []
          c.narrower_relations.each do |rel|
            narrower << "https://disability.openactive.io/participant-condition-supported##{rel.target.origin[1..-1]}"
          end
          klass = Iqvoc::Concept.further_relation_classes.first # XXX: arbitrary; bad heuristic?
          only_published = params[:published] != "0"
          related = []
          c.related_concepts_for_relation_class(klass, only_published).each do |related_concept|
            related << "https://disability.openactive.io/participant-condition-supported##{related_concept.origin[1..-1]}"
          end
          concept = {
              id: url,
              identifier: c.origin[1..-1],
              type: "Concept",
              prefLabel: c.pref_label.to_s
          }
          concept[:broader] = broader if broader.any?
          concept[:narrower] = narrower if narrower.any?
          concept[:related] = related if related.any?
          c.notes_for_class(Note::SKOS::Definition).each do |n|
            concept[:definition] = n.value
          end
          c.notations.each do |n|
            concept[:notation] = n.value
          end

          concept[:topConceptOf] = "https://disability.openactive.io/participant-condition-supported" if c.top_term?
          c.alt_labels.each do |l|
            concept[:altLabel] ||= []
            concept[:altLabel] << l.value
          end
          concept
        end
        raw_hash = {
            "@context": "https://openactive.io/",
            id: "https://disability.openactive.io/participant-condition-supported",
            title: "OpenActive Participant Condition Supported List",
            description: "A SKOS vocabulary for medical states and conditions affecting accessibility for physical activities",
            type: "ConceptScheme",
            license: "https://creativecommons.org/licenses/by/4.0/",
            concept: concepts
        }
        render json: raw_hash
        pretty_json = JSON.pretty_generate(raw_hash)

        # Create collections jsonld files (which are not validated)

        collections = @collections.select { |c| can? :read, c }.each do |c|
          collectionname = c.origin[1..-1]
          filename = "collections/#{collectionname}.jsonld"
          url = "https://disability.openactive.io/participant-condition-supported#{filename}"
          members = []
          c.concepts.each do |rel|
            members << "https://disability.openactive.io/participant-condition-supported##{rel.origin[1..-1]}"
          end
          collection = {
              "@context": "https://openactive.io/",
              "@type": "ConceptCollection",
              "@id": url,
              prefLabel: c.pref_label.to_s,
              inScheme: "https://disability.openactive.io/participant-condition-supported",
              license: "https://creativecommons.org/licenses/by/4.0/"
          }
          c.alt_labels.each do |l|
            collection[:altLabel] ||= []
            collection[:altLabel] << l.value
          end
          c.notes_for_class(Note::SKOS::Definition).each do |n|
            collection[:definition] = n.value
          end
          collection[:member] = members if members.any?
          collection_pretty_json = JSON.pretty_generate(collection)

        end
      end
    end
  end
end
