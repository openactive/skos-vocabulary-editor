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

require 'zip'


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
      format.zip do
        # Create in-memory zip file
        buffer = Zip::OutputStream.write_buffer do |zip|
          # Adding unvalidated_activity_list.jsonld to the ZIP
          concepts_json = generate_concepts_json(@concepts) # This method encapsulates the JSON generation logic
          zip.put_next_entry('unvalidated_activity_list.jsonld')
          zip.write(concepts_json)

          # Generate and add collections JSON files
          @collections.each do |collection|
            collection_json = generate_collection_json(collection) # This method encapsulates the JSON generation logic
            zip.put_next_entry("collections/#{collection.origin[1..-1]}.jsonld")
            zip.write(collection_json)
          end
        end

        # Rewind the buffer to allow for reading
        buffer.rewind

        # Send the data to the client as a file download
        send_data(buffer.read, filename: 'activity_list_with_collections.zip', type: 'application/zip')
      end
    end
  end

  private

  # Define the methods to generate JSON for concepts and collections
  def generate_concepts_json(concepts)
    concepts_map = concepts.select { |c| can? :read, c }.map do |c|
      concept_data = {
        id: "https://openactive.io/activity-list##{c.origin[1..-1]}",
        identifier: c.origin[1..-1],
        type: "Concept",
        prefLabel: c.pref_label.to_s
      }
  
      # Broader and narrower relations
      concept_data[:broader] = c.broader_relations.map { |rel| "https://openactive.io/activity-list##{rel.target.origin[1..-1]}" } if c.broader_relations.any?
      concept_data[:narrower] = c.narrower_relations.map { |rel| "https://openactive.io/activity-list##{rel.target.origin[1..-1]}" } if c.narrower_relations.any?
  
      # Related concepts, definitions, notations, and alternative labels
      # Adjust these parts based on your model's methods and attributes
      related, definitions, notations, alt_labels = [], [], [], []
      c.related_concepts.each { |related_concept| related << "https://openactive.io/activity-list##{related_concept.origin[1..-1]}" }
      concept_data[:related] = related if related.any?
  
      c.notes.each { |note| definitions << note.value if note.type == "Definition" }
      concept_data[:definition] = definitions.first if definitions.any?
  
      c.notations.each { |notation| notations << notation.value }
      concept_data[:notation] = notations.first if notations.any?
  
      c.alt_labels.each { |label| alt_labels << label.value }
      concept_data[:altLabel] = alt_labels if alt_labels.any?
  
      concept_data
    end
  
    # Wrapping the concepts in a larger JSON structure
    json_structure = {
      "@context": "https://openactive.io/",
      id: "https://openactive.io/activity-list",
      title: "OpenActive Activity List",
      description: "This document describes the OpenActive standard activity list.",
      type: "ConceptScheme",
      license: "https://creativecommons.org/licenses/by/4.0/",
      concept: concepts_map
    }
    JSON.pretty_generate(json_structure)
  end

  def generate_collection_json(collection)
    collection_json = {
      "@context": "https://openactive.io/",
      "@type": "ConceptCollection",
      "@id": "https://openactive.io/activity-list/collections/#{collection.origin[1..-1]}.jsonld",
      prefLabel: collection.pref_label.to_s,
      inScheme: "https://openactive.io/activity-list",
      license: "https://creativecommons.org/licenses/by/4.0/"
    }
  
    # Adding members, alternative labels, and definitions
    members = collection.members.map { |member| "https://openactive.io/activity-list##{member.origin[1..-1]}" }
    collection_json[:member] = members if members.any?
  
    alt_labels = collection.alt_labels.map(&:value)
    collection_json[:altLabel] = alt_labels if alt_labels.any?
  
    definitions = collection.notes.select { |note| note.type == "Definition" }.map(&:value)
    collection_json[:definition] = definitions.first if definitions.any?
  
    JSON.pretty_generate(collection_json)
  end
end
