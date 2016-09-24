class Classroom
    attr_accessor :curriculums,:users

    def initialize(filename=nil)
        @curriculums = {}
        @users = {}
        if filename
            file = File.open(filename, "r")
            parse(file) if file
        end
    end

    def generate_quiz_for_user(id, how_many)
        user = @users[id]
        #assume all curriculums and ignore user for now
        evenly = how_many / @curriculums.length
        remainder = how_many % @curriculums.length
        requests = Hash[@curriculums.map { |k, v| [k, evenly] }]
        @curriculums.keys.shuffle.take(remainder).each{ |k| requests[k] += 1 }
        return requests.map do |k, number|
            @curriculums[k].question_list(number)
        end.inject(&:+)
    end

    private
    def parse(file)
        expected_header = [:curriculum_id,:curriculum_name,:concept_id,:concept_name,:question_id,:difficulty]
        header = file.readline.strip.split(",").map(&:to_sym)
        raise "Bad Format" unless header == expected_header
        file.readlines.each do |line|
            curriculum_id,curriculum_name,concept_id,concept_name,question_id,difficulty = line.strip.split(",")
            curriculum = @curriculums[curriculum_id.to_i]
            unless curriculum
                curriculum = Curriculum.new(curriculum_id.to_i, curriculum_name)
                @curriculums[curriculum_id.to_i] = curriculum
            end
            concept = curriculum.concepts[concept_id.to_i]
            unless concept
                concept = Concept.new(concept_id.to_i, concept_name, curriculum)
                curriculum.concepts[concept_id.to_i] = concept
            end
            raise "overwriting question is bad" if concept.questions[question_id.to_i]
            question = Question.new(question_id.to_i, difficulty, concept)
            concept.questions[question_id.to_i] = question
        end
    end
end

class Curriculum
    attr_accessor :concepts, :id, :name

    def initialize(id, name, concepts=Hash.new())
        @id = id
        @name = name
        @concepts = concepts
    end

    def concept_count
        @concepts.length
    end

    def question_count
        @concepts.values.map(&:question_count).inject(&:+)
    end

    def question_list(number)
        evenly = number / @concepts.length
        remainder = number % @concepts.length
        requests = Hash[@concepts.map { |k, v| [k, evenly] }]
        @concepts.keys.shuffle.take(remainder).each{ |k| requests[k] += 1 }
        return requests.map do |k, n|
            @concepts[k].question_list(n)
        end.inject(&:+)
    end

end

class Concept
    attr_accessor :questions, :id, :name

    def initialize(id, difficulty, curriculum=nil, questions=Hash.new())
        @id = id
        @name = name
        @questions = questions
    end

    def question_count
        @questions.length
    end

    def question_list(length)
        long_enough = (@questions.keys.shuffle) * (1 + length / question_count)
        return long_enough.take(length)
    end
end

class Question
    attr_accessor :id, :difficulty

    def initialize(id, difficulty, concept=nil)
        @id = id
        @difficulty = difficulty
        @concept = concept
    end
end


if __FILE__ == $0
    file, user, number = ARGV
    room = Classroom.new(file)
    puts room.generate_quiz_for_user(user.to_i, number.to_i)
end
