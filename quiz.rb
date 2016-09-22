class Classroom
    def initialize(filename=nil)
        @strands = {}
        @users = {}
        if filename
            file = File.open(filename, "r")
            self.parse(file) if file
        end
    end

    def generate_quiz_for_user(id, how_many)
        user = @users[id]
        return [0]*how_many if user
    end

    private
    def parse(file)
        expected_header = [:strand_id,:strand_name,:standard_id,:standard_name,:question_id,:difficulty]
        header = file.readline.split(",").map(:to_sym)
        raise "Bad Format" unless header == expected_header
        file.readlines.each do |line|
            strand_id,strand_name,standard_id,standard_name,question_id,difficulty = line.split(",")
            strand = @strands[strand_id]
            unless strand
                #make strand
            end
            standard = strand.standards[standard_id]
            unless standard
                #make standard
            end
            question = Question(question_id, difficulty, standard)
            standard.questions[question_id] = question
        end
    end
end

def Strand
    def initialize(id, name, standards=Hash.new())
        @id = id
        @name = name
        @standards = standards
    end

    def standard_count
        @standards.length
    end
end

def Standard
    def initialize(id, difficulty, strand=nil, questions=Hash.new())
        @id = id
        @name = name
        @questions = questions
    end

    def question_count
        @questions.length
    end
end

def Question
    def initialize(id, difficulty, standard=nil)
        @id = id
        @difficulty = difficulty
        @standard = standard
    end
end
