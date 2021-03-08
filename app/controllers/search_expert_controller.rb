class SearchExpertController

  def self.search_closest_expert(member, target_hashed_terms)
    visited = Set.new
    queue = []
    parent = Hash.new
    expert = nil

    queue.push({member: member, level: 0})
    parent[member.id] = nil

    while expert.nil? && queue.any?
      curr = queue.pop
      visited.add(curr[:member].id)

      if curr[:level] > 1 &&  # The expert can't be a friend of the member
        final_node(curr[:member], target_hashed_terms)
        expert = curr[:member]  # Expert found!
      else
        curr[:member].friends.each do |f|
          unless visited.include?(f.id)
            visited.add(f.id)
            queue.push({member: f, level: curr[:level] + 1})
            parent[f.id] = curr[:member]
          end
        end
      end
    end

    return '' if expert.nil?

    # Build result if found
    result = expert.name
    curr_person = expert

    loop do
      curr_person = parent[curr_person.id]

      result = curr_person.name + ' -> ' + result
      break if curr_person.id == member.id
    end

    result
  end

  private

  def self.final_node(member, target_hashed_terms)
    curr_terms = member.headings.hashed_terms

    target_hashed_terms.each do |target_term|
      return false unless curr_terms.include?(target_term)
    end

    true
  end

end
