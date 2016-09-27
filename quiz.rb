require "byebug"

def questions_from_dict(number_wanted, dict)
    #outputs array of keys with the desired number of elements
    # requires that the elements of the dict have a :question_list method
    # and use that to pick within them
    quotient, remainder = number_wanted.divmod(dict.length)
    Hash[dict.keys.shuffle.each_with_index.map do |k, idx|
        [k, quotient + (idx < remainder ? 1 : 0) ]
    end ].map { |k, n| dict[k].question_list(n) }.inject(&:+)
end

class Classroom
    attr_accessor :curriculums,:users

    def initialize(question_filename=nil)
        @curriculums = {}
        @users = {}
        if question_filename
            file = File.open(question_filename, "r")
            parse_questions(file) if file
        end
    end

    def generate_quiz_for_user(id, how_many)
        user = @users[id]
        #assume all curriculums and ignore user for now
        questions_from_dict(how_many, @curriculums)
    end

    private
    def parse_questions(file)
        expected_header = [:curriculum_id, :curriculum_name,
                           :concept_id, :concept_name,
                           :question_id, :difficulty]
        header = file.readline.strip.split(",").map(&:to_sym)
        raise "Bad Format For Question File" unless header == expected_header
        file.readlines.each do |line|
            curriculum_id,curriculum_name,concept_id,concept_name,question_id,difficulty = line.strip.split(",")
            curriculum = @curriculums[curriculum_id.to_i]
            unless curriculum
                curriculum = Curriculum.new(curriculum_id.to_i, curriculum_name)
                @curriculums[curriculum.id] = curriculum
            end
            concept = curriculum.concepts[concept_id.to_i]
            unless concept
                concept = Concept.new(concept_id.to_i, concept_name, curriculum)
                curriculum.concepts[concept.id] = concept
            end
            raise "overwriting question is bad" if concept.questions[question_id.to_i]
            question = Question.new(question_id.to_i, difficulty.to_f, concept)
            concept.questions[question.id] = question
        end
    end

    def parse_users(file)
        expected_header = [:student_id, :question_id,
                           :assigned_hour_ago, :answered_hours_ago]
        header = file.readline.strip.split(",").map(&:to_sym)
        raise "Bad Format For User File" unless header == expected_header
    end
end

class Curriculum
    attr_reader :id, :name, :concepts

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
        questions_from_dict(number, @concepts)
    end

end

class Concept
    attr_accessor :questions
    attr_reader :id, :name, :curriculum

    def initialize(id, name, curriculum=nil, questions=Hash.new())
        @id = id
        @curriculum = curriculum
        @name = name
        @questions = questions
    end

    def question_count
        @questions.length
    end

    def question_list(length)
        long_enough = (@questions.values.shuffle) * (1 + length / question_count)
        picked = long_enough.take(length).sort_by { |question| question.difficulty }
        return picked.map(&:id)
    end
end

class Question
    attr_reader :id, :difficulty, :concept

    def initialize(id, difficulty, concept=nil)
        @id = id
        @difficulty = difficulty
        @concept = concept
    end
end

class Student
end


if __FILE__ == $0
    file, number, user_data, user = ARGV
    room = Classroom.new(file)
    puts room.generate_quiz_for_user(user.to_i, number.to_i).to_s
end
