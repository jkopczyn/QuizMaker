class Classroom
    attr_accessor :strands,:users

    def initialize(filename=nil)
        @strands = {}
        @users = {}
        if filename
            file = File.open(filename, "r")
            parse(file) if file
        end
    end

    def generate_quiz_for_user(id, how_many)
        user = @users[id]
        #assume all strands and ignore user for now
        evenly = how_many / @strands.length
        remainder = how_many % @strands.length
        requests = Hash[@strands.map { |k, v| [k, evenly] }]
        @strands.keys.shuffle.take(remainder).each{ |k| requests[k] += 1 }
        return requests.map do |k, number|
            @strands[k].question_list(number)
        end.inject(&:+)
    end

    private
    def parse(file)
        expected_header = [:strand_id,:strand_name,:standard_id,:standard_name,:question_id,:difficulty]
        header = file.readline.strip.split(",").map(&:to_sym)
        raise "Bad Format" unless header == expected_header
        file.readlines.each do |line|
            strand_id,strand_name,standard_id,standard_name,question_id,difficulty = line.strip.split(",")
            strand = @strands[strand_id.to_i]
            unless strand
                strand = Strand.new(strand_id.to_i, strand_name)
                @strands[strand_id.to_i] = strand
            end
            standard = strand.standards[standard_id.to_i]
            unless standard
                standard = Standard.new(standard_id.to_i, standard_name, strand)
                strand.standards[standard_id.to_i] = standard
            end
            raise "overwriting question is bad" if standard.questions[question_id.to_i]
            question = Question.new(question_id.to_i, difficulty, standard)
            standard.questions[question_id.to_i] = question
        end
    end
end

class Strand
    attr_accessor :standards, :id, :name

    def initialize(id, name, standards=Hash.new())
        @id = id
        @name = name
        @standards = standards
    end

    def standard_count
        @standards.length
    end

    def question_count
        @standards.values.map(&:question_count).inject(&:+)
    end

    def question_list(number)
        evenly = number / @standards.length
        remainder = number % @standards.length
        requests = Hash[@standards.map { |k, v| [k, evenly] }]
        @standards.keys.shuffle.take(remainder).each{ |k| requests[k] += 1 }
        return requests.map do |k, n|
            @standards[k].question_list(n)
        end.inject(&:+)
    end

end

class Standard
    attr_accessor :questions, :id, :name

    def initialize(id, difficulty, strand=nil, questions=Hash.new())
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

    def initialize(id, difficulty, standard=nil)
        @id = id
        @difficulty = difficulty
        @standard = standard
    end
end


file, user, number = ARGV
room = Classroom.new(file)
puts room.generate_quiz_for_user(user.to_i, number.to_i)
